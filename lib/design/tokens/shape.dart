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

/// Semantic shape tokens.
///
/// Defines corner radius, stroke thickness, and divider weight intent
/// independent of decorations or widgets. Platform implementations
/// interpret these to feel native while preserving brand character.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [AppShapeTokens.of] without runtime checks.
abstract class AppShape {
  const AppShape();

  /// Maximum radius value used for fully rounded elements.
  /// Produces circular or pill shapes when applied to height-constrained
  /// elements. Consumers should use [full] rather than this constant.
  static const double maxRadius = 1000.0;

  // ──────────────────────────────────────────────────────────
  // Corner Radius
  // ──────────────────────────────────────────────────────────

  /// No rounding. Deliberately rectangular.
  /// Use for structural elements, dividers, progress tracks.
  double get none;

  /// Subtle softening. Barely perceptible rounding.
  /// Use for small components: chips, tags, badges, inline buttons.
  double get sm;

  /// Default comfortable rounding. Friendly but not playful.
  /// Use for most touchable surfaces: cards, buttons, inputs.
  double get md;

  /// Pronounced rounding. Soft and welcoming.
  /// Use for dialogs, sheets, FABs, prominent containers.
  double get lg;

  /// Fully rounded to circular or pill shape.
  /// Produces circular shapes on square elements, pill shapes on
  /// width-constrained elements. Use ONLY for avatars, circular
  /// buttons, toggle thumbs, and explicitly pill-shaped elements.
  double get full;

  // ──────────────────────────────────────────────────────────
  // Stroke Thickness
  // ──────────────────────────────────────────────────────────

  /// No visible border.
  /// Surface relies on elevation or fill for definition.
  double get strokeNone;

  /// Barely visible border for structural definition.
  /// Use for inactive inputs, subtle container edges.
  double get strokeSubtle;

  /// Clearly visible border for emphasis or state.
  /// Use for focus states, outlined buttons, selection.
  double get strokeVisible;

  // ──────────────────────────────────────────────────────────
  // Divider Weight
  //
  // These tokens represent relative visual weight, not guaranteed
  // pixel thickness. Actual rendering may vary by context and
  // display density. Use these to communicate separation intent.
  // ──────────────────────────────────────────────────────────

  /// No visible divider.
  /// Separation through spacing alone.
  double get dividerNone;

  /// Minimal visual weight. Present but quiet.
  /// Use between list items, within-card sections.
  double get dividerSubtle;

  /// Clear visual weight for explicit separation.
  /// Use between major sections, below navigation.
  double get dividerVisible;
}

/// iOS interpretation.
///
/// Softer, more generous rounding. Organic and blended feel.
/// Borders are understated. Dividers are very subtle.
/// Shapes feel natural and flowing.
class _IosShape extends AppShape {
  const _IosShape();

  @override
  double get none => 0.0;

  @override
  double get sm => 6.0;

  @override
  double get md => 14.0;

  @override
  double get lg => 22.0;

  @override
  double get full => AppShape.maxRadius;

  @override
  double get strokeNone => 0.0;

  @override
  double get strokeSubtle => 0.5;

  @override
  double get strokeVisible => 1.5;

  @override
  double get dividerNone => 0.0;

  @override
  double get dividerSubtle => 0.5;

  @override
  double get dividerVisible => 1.0;
}

/// Android interpretation.
///
/// Cleaner, more structured rounding. Precise and intentional feel.
/// Borders are acceptable and defined. Dividers are slightly more visible.
/// Shapes feel deliberate and organized.
class _AndroidShape extends AppShape {
  const _AndroidShape();

  @override
  double get none => 0.0;

  @override
  double get sm => 4.0;

  @override
  double get md => 12.0;

  @override
  double get lg => 20.0;

  @override
  double get full => AppShape.maxRadius;

  @override
  double get strokeNone => 0.0;

  @override
  double get strokeSubtle => 1.0;

  @override
  double get strokeVisible => 2.0;

  @override
  double get dividerNone => 0.0;

  @override
  double get dividerSubtle => 1.0;

  @override
  double get dividerVisible => 1.5;
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
/// Values are intentionally balanced between iOS and Android.
class _DefaultShape extends AppShape {
  const _DefaultShape();

  @override
  double get none => 0.0;

  @override
  double get sm => 5.0;

  @override
  double get md => 12.0;

  @override
  double get lg => 20.0;

  @override
  double get full => AppShape.maxRadius;

  @override
  double get strokeNone => 0.0;

  @override
  double get strokeSubtle => 0.75;

  @override
  double get strokeVisible => 1.5;

  @override
  double get dividerNone => 0.0;

  @override
  double get dividerSubtle => 0.75;

  @override
  double get dividerVisible => 1.25;
}

/// Static shape resolver.
///
/// Platform detection occurs once when this class is first loaded.
/// The resolved scale is cached for the lifetime of the application.
/// This guarantees deterministic shape and avoids runtime branching.
abstract final class AppShapeTokens {
  AppShapeTokens._();

  /// Platform-appropriate shape tokens.
  static AppShape get of => _resolved;

  static final AppShape _resolved = _resolve();

  static AppShape _resolve() {
    try {
      if (Platform.isIOS) return const _IosShape();
      if (Platform.isAndroid) return const _AndroidShape();
    } catch (_) {
      // Platform unavailable (e.g., web)
    }
    return const _DefaultShape();
  }
}
