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

/// Semantic spacing scale.
///
/// Defines layout rhythm tokens independent of widgets or components.
/// Platform implementations interpret these semantically, not literally.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [Spacing.of] without runtime checks.
abstract class AppSpacing {
  const AppSpacing();

  /// Intimate connection.
  /// Elements function as a single visual or functional unit.
  double get xs;

  /// Close relationship.
  /// Clearly related siblings with minimal separation.
  double get sm;

  /// Comfortable default.
  /// Standard inter-element rhythm for most layouts.
  double get md;

  /// Loose relationship.
  /// Distinct but related groups requiring separation.
  double get lg;

  /// Section boundary.
  /// Major content transitions and structural breaks.
  double get xl;
}

/// iOS interpretation.
///
/// Follows Apple HIG 8-point grid. iOS layouts favor tighter grouping
/// with smaller upper-tier jumps than Material. Values align with
/// standard UIKit margins and system component spacing.
class _IosSpacing extends AppSpacing {
  const _IosSpacing();

  @override
  double get xs => 4.0;

  @override
  double get sm => 8.0;

  @override
  double get md => 16.0;

  @override
  double get lg => 20.0;

  @override
  double get xl => 32.0;
}

/// Android interpretation.
///
/// Strict Material Design 3 spacing scale. Uses canonical M3 tokens:
/// 4, 8, 16, 24, 48. Larger upper-tier jumps reinforce structural
/// hierarchy per Material spatial system.
class _AndroidSpacing extends AppSpacing {
  const _AndroidSpacing();

  @override
  double get xs => 4.0;

  @override
  double get sm => 8.0;

  @override
  double get md => 16.0;

  @override
  double get lg => 24.0;

  @override
  double get xl => 48.0;
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
/// Values split the difference between iOS and Android upper tiers
/// to remain visually neutral on any platform.
class _DefaultSpacing extends AppSpacing {
  const _DefaultSpacing();

  @override
  double get xs => 4.0;

  @override
  double get sm => 8.0;

  @override
  double get md => 16.0;

  @override
  double get lg => 24.0;

  @override
  double get xl => 40.0;
}

/// Static spacing resolver.
///
/// Platform detection occurs once when this class is first loaded.
/// The resolved scale is cached for the lifetime of the application.
/// This guarantees deterministic spacing and avoids runtime branching.
abstract final class Spacing {
  Spacing._();

  /// Platform-appropriate spacing scale.
  static AppSpacing get of => _resolved;

  static final AppSpacing _resolved = _resolve();

  static AppSpacing _resolve() {
    try {
      if (Platform.isIOS) return const _IosSpacing();
      if (Platform.isAndroid) return const _AndroidSpacing();
    } catch (_) {
      // Platform unavailable (e.g., web)
    }
    return const _DefaultSpacing();
  }
}
