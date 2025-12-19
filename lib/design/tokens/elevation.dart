// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
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

import 'dart:io' show Platform;

/// Semantic elevation tokens.
///
/// Defines shadow depth and surface layering intent independent of
/// specific shadow values. Platform implementations interpret these
/// to feel native while preserving spatial hierarchy.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [AppElevationTokens.of] without runtime checks.
abstract class AppElevation {
  const AppElevation();

  // ──────────────────────────────────────────────────────────
  // Elevation Levels
  // ──────────────────────────────────────────────────────────

  /// No elevation. Surface sits at ground level.
  /// Use for inline content, backgrounds, dividers.
  double get none;

  /// Minimal elevation. Barely lifted.
  /// Use for cards, list items, subtle containers.
  double get low;

  /// Standard elevation. Clearly floating.
  /// Use for app bars, navigation bars, raised buttons.
  double get medium;

  /// High elevation. Prominent and attention-grabbing.
  /// Use for dialogs, sheets, FABs.
  double get high;
}

/// iOS interpretation.
///
/// iOS uses blur and translucency more than elevation.
/// Values are present for API compatibility but shadows are
/// typically subtle or absent in favor of blur effects.
class _IosElevation extends AppElevation {
  const _IosElevation();

  @override
  double get none => 0.0;

  @override
  double get low => 1.0;

  @override
  double get medium => 2.0;

  @override
  double get high => 4.0;
}

/// Android interpretation.
///
/// Android uses Material elevation semantics with clear shadow depth.
/// Values align with Material Design elevation scale.
class _AndroidElevation extends AppElevation {
  const _AndroidElevation();

  @override
  double get none => 0.0;

  @override
  double get low => 1.0;

  @override
  double get medium => 4.0;

  @override
  double get high => 8.0;
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
class _DefaultElevation extends AppElevation {
  const _DefaultElevation();

  @override
  double get none => 0.0;

  @override
  double get low => 1.0;

  @override
  double get medium => 3.0;

  @override
  double get high => 6.0;
}

/// Static elevation resolver.
///
/// Platform detection occurs once when this class is first loaded.
/// The resolved scale is cached for the lifetime of the application.
abstract final class AppElevationTokens {
  AppElevationTokens._();

  /// Platform-appropriate elevation tokens.
  static AppElevation get of => _resolved;

  static final AppElevation _resolved = _resolve();

  static AppElevation _resolve() {
    try {
      if (Platform.isIOS) return const _IosElevation();
      if (Platform.isAndroid) return const _AndroidElevation();
    } catch (_) {
      // Platform unavailable (e.g., web)
    }
    return const _DefaultElevation();
  }
}
