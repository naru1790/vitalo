// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tokens are resolved once per app run.
// TokenEnvironment must be initialized before access.
// Environment changes require app restart by design.
//
// This file defines system-level policy.
// Changes here are considered BREAKING CHANGES.
//
// Allowed changes:
// - Bug fixes with no semantic impact
// - Additive extensions approved via architecture review
//
// Forbidden changes:
// - Renaming semantics
// - Changing default values
// - Adding platform conditionals
// - Feature-driven modifications
// - Adding BuildContext or MediaQuery dependencies
// - Lazy or deferred token resolution
// - Silent fallbacks or defaults

import 'token_environment.dart';

/// Semantic opacity tokens.
///
/// Defines transparency levels for overlays, scrims, and translucent
/// surfaces. Platform implementations interpret these to feel native
/// while preserving visual hierarchy.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [AppOpacityTokens.of] without runtime checks.
abstract class AppOpacity {
  const AppOpacity();

  // ──────────────────────────────────────────────────────────
  // Surface Opacity
  // ──────────────────────────────────────────────────────────

  /// Fully opaque. No transparency.
  double get opaque;

  /// Translucent navigation bar background.
  /// Allows content to blur through while maintaining legibility.
  double get barBackground;

  /// Light scrim for subtle overlays.
  /// Use behind sheets, non-modal overlays.
  double get scrimLight;

  /// Heavy scrim for modal overlays.
  /// Use behind dialogs, alerts, modal sheets.
  double get scrimHeavy;

  /// Disabled state opacity.
  /// Applied to disabled controls and inactive elements.
  double get disabled;
}

/// iOS interpretation.
///
/// iOS uses more aggressive translucency for depth and blur effects.
/// Bar backgrounds are highly translucent to allow blur-through.
class _IosOpacity extends AppOpacity {
  const _IosOpacity();

  @override
  double get opaque => 1.0;

  @override
  double get barBackground => 0.9;

  @override
  double get scrimLight => 0.3;

  @override
  double get scrimHeavy => 0.5;

  @override
  double get disabled => 0.4;
}

/// Android interpretation.
///
/// Android uses slightly more opaque surfaces with less blur reliance.
/// Scrims are typically darker for clear modal distinction.
class _AndroidOpacity extends AppOpacity {
  const _AndroidOpacity();

  @override
  double get opaque => 1.0;

  @override
  double get barBackground => 0.95;

  @override
  double get scrimLight => 0.32;

  @override
  double get scrimHeavy => 0.6;

  @override
  double get disabled => 0.38;
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
class _DefaultOpacity extends AppOpacity {
  const _DefaultOpacity();

  @override
  double get opaque => 1.0;

  @override
  double get barBackground => 0.92;

  @override
  double get scrimLight => 0.3;

  @override
  double get scrimHeavy => 0.55;

  @override
  double get disabled => 0.4;
}

/// Static opacity resolver.
///
/// Resolution occurs at class load after TokenEnvironment initialization.
/// The resolved scale is immutable for the lifetime of the application.
abstract final class AppOpacityTokens {
  AppOpacityTokens._();

  /// Platform-appropriate opacity tokens.
  static AppOpacity get of => _resolved;

  static final AppOpacity _resolved = _resolve();

  static AppOpacity _resolve() {
    final platform = TokenEnvironment.current.platform;
    return switch (platform) {
      TokenPlatform.ios => const _IosOpacity(),
      TokenPlatform.android => const _AndroidOpacity(),
      TokenPlatform.other => const _DefaultOpacity(),
    };
  }
}
