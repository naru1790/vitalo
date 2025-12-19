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

import 'dart:ui' show Color;

import 'app_colors.dart';

/// iOS — Light appearance.
///
/// Parallel interpretation layer: light appearance values only.
/// No runtime logic, no derived colors.
class IosLightColors extends AppColors {
  const IosLightColors();

  @override
  Color get brandPrimary => const Color(0xFFF97316);

  @override
  Color get brandSecondary => const Color(0xFFEC4899);

  @override
  Color get brandAccent => const Color(0xFF06B6D4);

  @override
  Color get brandSurface => const Color(0xFFFFF7ED);

  @override
  Color get neutralBase =>
      // Light appearance assumption: foundational canvas for light UI.
      const Color(0xFFF5F5F4);

  @override
  Color get neutralSurface =>
      // Light appearance assumption: standard content surface.
      const Color(0xFFFFFFFF);

  @override
  Color get surfaceElevated =>
      // Light appearance assumption: highest-elevation surface.
      const Color(0xFFFFFFFF);

  @override
  Color get neutralDivider => const Color(0xFFC6C6C8);

  @override
  Color get textPrimary => const Color(0xFF1F1F1F);

  @override
  Color get textSecondary => const Color(0xFF8E918F);

  @override
  Color get textTertiary => const Color(0xFFC6C6C8);

  @override
  Color get textInverse =>
      // Light appearance assumption: inverse text for dark/saturated surfaces.
      const Color(0xFFFFFFFF);

  @override
  Color get feedbackSuccess => const Color(0xFF22C55E);

  @override
  Color get feedbackWarning => const Color(0xFFF59E0B);

  @override
  Color get feedbackError => const Color(0xFFEF4444);

  @override
  Color get feedbackInfo => const Color(0xFF5C6BC0);

  @override
  Color get stateActive =>
      // Intentionally aligned with brandPrimary value.
      // Semantic independence: stateActive communicates interaction feedback,
      // not brand identity.
      const Color(0xFFF97316);

  @override
  Color get stateHover =>
      // Hover affordance is not applicable on touch-only platforms.
      // Token remains to preserve cross-platform semantics.
      const Color(0x00000000);

  @override
  Color get stateDisabled => const Color(0xFFC6C6C8);

  @override
  Color get stateFocus =>
      // Intentionally aligned with brandPrimary family.
      // Semantic independence: stateFocus communicates accessibility focus,
      // not branding.
      const Color(0xFFEA580C);

  @override
  Color get stateSelected =>
      // Intentionally aligned with brandPrimary family.
      // Semantic independence: stateSelected communicates persistent selection,
      // not branding.
      const Color(0xFFFDBA74);

  @override
  Color get overlayDark => const Color(0x66000000);

  @override
  Color get overlayLight => const Color(0x66FFFFFF);

  @override
  Color get scrim => const Color(0x99000000);

  @override
  Color get skeleton =>
      // iOS may prefer a lighter, softer placeholder tone.
      const Color(0xFFF2F2F7);

  @override
  Color get chartPrimary =>
      // Intentionally aligned with brandPrimary value.
      // Semantic independence: chartPrimary is for data emphasis, not branding.
      const Color(0xFFF97316);

  @override
  Color get chartSecondary =>
      // Intentionally aligned with brandSecondary value.
      // Semantic independence: chartSecondary is for comparisons, not branding.
      const Color(0xFFEC4899);

  @override
  Color get chartTertiary =>
      // Intentionally aligned with brandAccent value.
      // Semantic independence: chartTertiary is for additional series, not branding.
      const Color(0xFF06B6D4);
}
