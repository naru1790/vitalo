import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../tokens/color.dart';
import '../tokens/token_environment.dart';
import 'android_shell.dart';
import 'ios_shell.dart';
import 'platform/app_environment_scope.dart';

// @frozen
// TIER-0 INFRASTRUCTURE — ACTIVE FREEZE ZONE
//
// Environment Owner — resolves raw inputs and produces semantic outputs.
//
// Raw inputs consumed here (STOP here, never flow down):
// - System brightness (MediaQuery.platformBrightnessOf)
// - Platform detection (Platform.isIOS/isAndroid)
// - TokenEnvironment initialization
//
// Semantic outputs exported (FLOW down via scope):
// - AppColors via AppColorScope
// - AppPlatform via AppPlatformScope (in platform shells)
// - NavMotionDelegate via NavMotionScope (in platform shells)
//
// ARCHITECTURAL INVARIANTS:
// - No other file may call TokenEnvironment.initialize().
// - Brightness terminates here — only semantic colors cross scope boundaries.
// - Platform shells receive brightness via constructor for theme configuration only.

/// Adaptive shell that owns platform + appearance resolution.
///
/// Resolves brightness from system, resolves semantic colors, and branches
/// to platform-specific shells. Contains no UI or routing logic.
///
/// Uses [StatefulWidget] to guarantee [TokenEnvironment.initialize]
/// runs exactly once before any token access occurs.
class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key, required this.child});

  final Widget child;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();

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

class _AdaptiveShellState extends State<AdaptiveShell> {
  @override
  void initState() {
    super.initState();

    /// Initializes TokenEnvironment.
    /// Must execute before any token access.
    /// Architectural invariant — do not move.
    _initializeTokenEnvironment();
  }

  /// Initialize the token environment once at app startup.
  ///
  /// This must be called exactly once, in [initState], before [build].
  /// Re-initialization will throw an assertion error.
  /// No conditional initialization. No retries.
  void _initializeTokenEnvironment() {
    TokenPlatform platform;
    try {
      if (Platform.isIOS) {
        platform = TokenPlatform.ios;
      } else if (Platform.isAndroid) {
        platform = TokenPlatform.android;
      } else {
        platform = TokenPlatform.other;
      }
    } catch (_) {
      // Platform unavailable (e.g., web)
      platform = TokenPlatform.other;
    }

    TokenEnvironment.initialize(
      TokenEnvironment(
        platform: platform,
        // Density and text scale policy can be expanded later
        // based on device characteristics if needed.
        density: DensityClass.regular,
        textScalePolicy: TextScalePolicy.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ═══════════════════════════════════════════════════════════════════════
    // RAW INPUT RESOLUTION — brightness terminates here
    // ═══════════════════════════════════════════════════════════════════════
    final brightness = MediaQuery.platformBrightnessOf(context);
    final colors = AppColorsResolver.resolve(brightness: brightness);

    final forced = AdaptiveShell._forcedPlatform;

    // Debug-only preview override.
    // Allows designers/devs to preview iOS/Android shell styling on any host.
    // Intentionally ignored in release builds.
    final Widget shell;

    // Platform shells receive brightness for theme configuration only.
    // They do not expose brightness to descendants.
    if (!kReleaseMode && forced != null) {
      shell = forced == _ForcedPlatform.ios
          ? IosShell(
              brightness: brightness,
              colors: colors,
              child: widget.child,
            )
          : AndroidShell(
              brightness: brightness,
              colors: colors,
              child: widget.child,
            );
    } else {
      shell = AdaptiveShell._isIos
          ? IosShell(
              brightness: brightness,
              colors: colors,
              child: widget.child,
            )
          : AndroidShell(
              brightness: brightness,
              colors: colors,
              child: widget.child,
            );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // SEMANTIC OUTPUT — only colors cross this boundary
    // ═══════════════════════════════════════════════════════════════════════
    return AppColorScope(colors: colors, child: shell);
  }
}

enum _ForcedPlatform { ios, android }
