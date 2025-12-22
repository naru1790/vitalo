import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../tokens/color.dart';
import 'android_shell.dart';
import 'ios_shell.dart';

/// Adaptive shell that owns platform + appearance resolution.
///
/// Resolves brightness from system, resolves tokens, and branches
/// to platform-specific shells. Contains no UI or routing logic.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final colors = AppColorsTokens.resolve(brightness: brightness);

    final forced = _forcedPlatform;

    // Debug-only preview override.
    // Allows designers/devs to preview iOS/Android shell styling on any host.
    // Intentionally ignored in release builds.
    if (!kReleaseMode && forced != null) {
      if (forced == _ForcedPlatform.ios) {
        return IosShell(brightness: brightness, colors: colors, child: child);
      }
      return AndroidShell(brightness: brightness, colors: colors, child: child);
    }

    if (_isIos) {
      return IosShell(brightness: brightness, colors: colors, child: child);
    }
    return AndroidShell(brightness: brightness, colors: colors, child: child);
  }

  // Set via: --dart-define=VITALO_FORCE_PLATFORM=ios|android
  // Note: This affects only the shell (widget styling + AppPlatformScope),
  // not any token resolvers that use dart:io Platform.
  static const String _forcePlatform = String.fromEnvironment(
    'VITALO_FORCE_PLATFORM',
  );

  static _ForcedPlatform? get _forcedPlatform {
    final value = _forcePlatform.trim().toLowerCase();
    return switch (value) {
      'ios' => _ForcedPlatform.ios,
      'android' => _ForcedPlatform.android,
      _ => null,
    };
  }

  static bool get _isIos {
    try {
      return Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}

enum _ForcedPlatform { ios, android }
