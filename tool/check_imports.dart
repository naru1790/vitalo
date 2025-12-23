/// ═══════════════════════════════════════════════════════════════════════════
/// ARCHITECTURAL IMPORT CHECKER
/// ═══════════════════════════════════════════════════════════════════════════
///
/// This script enforces the design system import architecture:
///
/// ┌───────────────────────────────────────────────────────────────────────────┐
/// │ RULE: Feature code must NOT import raw framework or internal design      │
/// ├───────────────────────────────────────────────────────────────────────────┤
/// │ ✗ import 'package:flutter/material.dart'         → FORBIDDEN             │
/// │ ✗ import 'package:flutter/cupertino.dart'        → FORBIDDEN             │
/// │ ✗ import '...design/tokens/...'                  → FORBIDDEN             │
/// │ ✗ import '...design/adaptive/...' (internals)    → FORBIDDEN             │
/// │ ✓ import 'package:vitalo/design/design.dart'     → ALLOWED               │
/// └───────────────────────────────────────────────────────────────────────────┘
///
/// Usage:
///   dart run tool/check_imports.dart
///   dart run tool/check_imports.dart --fix  (shows what to change)
///   dart run tool/check_imports.dart --tier1-layout  (only landing/email/otp)
///
/// Exit codes:
///   0 = All imports are valid
///   1 = Violations found
library check_imports;

// ignore_for_file: avoid_print

import 'dart:io';

/// Files/folders that are EXEMPT from these rules (they ARE the design layer)
const exemptPaths = [
  'lib/design/',
  'lib/main.dart', // main.dart is allowed to import AdaptiveShell
  'lib/core/', // core utilities may need framework access
];

class ImportRule {
  final String pattern;
  final String message;
  final bool isWidgetPattern;

  const ImportRule(this.pattern, this.message, {this.isWidgetPattern = false});

  RegExp get regex => RegExp(pattern);
}

/// Forbidden import patterns for feature code
const forbiddenPatterns = [
  // Raw framework imports
  ImportRule(
    r'import\s+.package:flutter/material\.dart',
    'Direct Material import forbidden. Use: import package:vitalo/design/design.dart',
  ),
  ImportRule(
    r'import\s+.package:flutter/cupertino\.dart',
    'Direct Cupertino import forbidden. Use: import package:vitalo/design/design.dart',
  ),
  // Internal design imports (tokens, internals)
  ImportRule(
    r'import\s+.+design/tokens/',
    'Direct token import forbidden. Use: import package:vitalo/design/design.dart',
  ),
  ImportRule(
    r'import\s+.+design/adaptive/[^w]',
    'Direct adaptive internal import forbidden. Use: import package:vitalo/design/design.dart',
  ),
  // Raw widget usage (these are harder to detect but we can flag common ones)
  ImportRule(
    r'\bText\s*\(',
    'Raw Text() widget detected. Use AppText() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bElevatedButton\s*\(',
    'Raw ElevatedButton() detected. Use AppButton() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bCupertinoButton\s*\(',
    'Raw CupertinoButton() detected. Use AppButton() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bTextButton\s*\(',
    'Raw TextButton() detected. Use AppButton() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bScaffold\s*\(',
    'Raw Scaffold() detected. Use AppScaffold() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bCupertinoPageScaffold\s*\(',
    'Raw CupertinoPageScaffold() detected. Use AppScaffold() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bTextField\s*\(',
    'Raw TextField() detected. Use AppTextField() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bCupertinoTextField\s*\(',
    'Raw CupertinoTextField() detected. Use AppTextField() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bIcon\s*\(',
    'Raw Icon() detected. Use AppIcon() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bIconButton\s*\(',
    'Raw IconButton() detected. Use AppIconButton() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bDivider\s*\(',
    'Raw Divider() detected. Use AppDivider() from design.dart',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bListTile\s*\(',
    'Raw ListTile() detected. Use AppListTile() from design.dart',
    isWidgetPattern: true,
  ),

  // Tier-1 feature layout lockdown (only enforced with --strict)
  ImportRule(
    r'\bPadding\s*\(',
    'Raw Padding() detected. Use AppPageBody() for padding in feature code.',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bEdgeInsets\b',
    'Raw EdgeInsets detected. Use AppPageBody() padding options in feature code.',
    isWidgetPattern: true,
  ),
  ImportRule(
    r'\bSingleChildScrollView\s*\(',
    'Raw SingleChildScrollView() detected. Use AppPageBody() scroll options in feature code.',
    isWidgetPattern: true,
  ),
];

class Violation {
  final String filePath;
  final int lineNumber;
  final String line;
  final String message;

  Violation({
    required this.filePath,
    required this.lineNumber,
    required this.line,
    required this.message,
  });
}

void main(List<String> args) {
  final showFix = args.contains('--fix');
  final tier1Layout = args.contains('--tier1-layout');
  final checkWidgets = args.contains('--strict') || tier1Layout;

  print('');
  print(
    '═══════════════════════════════════════════════════════════════════════',
  );
  print('  ARCHITECTURAL IMPORT CHECKER');
  print(
    '═══════════════════════════════════════════════════════════════════════',
  );
  print('');

  final featuresDir = Directory('lib/features');
  if (!featuresDir.existsSync()) {
    print('  ✓ No lib/features directory found. Nothing to check.');
    exit(0);
  }

  final violations = <Violation>[];
  final allDartFiles = featuresDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  final Iterable<File> dartFiles;
  if (tier1Layout) {
    const tier1Targets = <String>{
      'lib/features/landing/presentation/landing_screen.dart',
      'lib/features/auth/presentation/email_signin_screen.dart',
      'lib/features/auth/presentation/otp_verification_screen.dart',
    };

    dartFiles = allDartFiles.where((file) {
      final relativePath = file.path.replaceAll(r'\\', '/');
      return tier1Targets.contains(relativePath);
    });
  } else {
    dartFiles = allDartFiles;
  }

  for (final file in dartFiles) {
    final relativePath = file.path.replaceAll(r'\', '/');

    // Check if file is exempt
    if (exemptPaths.any((exempt) => relativePath.contains(exempt))) {
      continue;
    }

    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      for (final rule in forbiddenPatterns) {
        // Skip widget patterns unless --strict is specified
        if (rule.isWidgetPattern && !checkWidgets) continue;

        if (rule.regex.hasMatch(line)) {
          violations.add(
            Violation(
              filePath: relativePath,
              lineNumber: lineNumber,
              line: line,
              message: rule.message,
            ),
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    print('  ✓ All feature imports follow architectural rules!');
    print('');
    if (!checkWidgets) {
      print('  Tip: Run with --strict to also check for raw widget usage.');
    }
    print('');
    exit(0);
  }

  print('  ✗ Found ${violations.length} violation(s):\n');

  // Group by file
  final byFile = <String, List<Violation>>{};
  for (final v in violations) {
    byFile.putIfAbsent(v.filePath, () => []).add(v);
  }

  for (final entry in byFile.entries) {
    print('  ${entry.key}:');
    for (final v in entry.value) {
      print('    Line ${v.lineNumber}: ${v.line.trim()}');
      print('    └─ ${v.message}');
      print('');
    }
  }

  if (showFix) {
    print(
      '═══════════════════════════════════════════════════════════════════════',
    );
    print('  HOW TO FIX');
    print(
      '═══════════════════════════════════════════════════════════════════════',
    );
    print('');
    print('  1. Replace forbidden imports with:');
    print("     import 'package:vitalo/design/design.dart';");
    print('');
    print('  2. Replace raw widgets with adaptive primitives:');
    print('     Text()       → AppText()');
    print('     Scaffold()   → AppScaffold()');
    print('     TextField()  → AppTextField()');
    print('     Icon()       → AppIcon()');
    print('     Divider()    → AppDivider()');
    print('     ListTile()   → AppListTile()');
    print('     *Button()    → AppButton()');
    print('     Padding()    → AppPageBody()');
    print('     EdgeInsets   → AppPageBody() padding');
    print('     SingleChildScrollView() → AppPageBody()');
    print('');
  }

  exit(1);
}
