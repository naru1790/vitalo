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

/// Default — Dark appearance.
///
/// Parallel interpretation layer used when platform detection is unavailable.
class DefaultDarkColors extends AppColors {
  const DefaultDarkColors();

  @override
  Color get brandPrimary => const Color(0xFFFB923C);

  @override
  Color get brandSecondary => const Color(0xFFF472B6);

  @override
  Color get brandAccent => const Color(0xFF22D3EE);

  @override
  Color get brandSurface => const Color(0xFF1E293B);

  @override
  Color get neutralBase =>
      // Deep, breathable near-black (not pure black).
      const Color(0xFF0F172A);

  @override
  Color get neutralSurface => const Color(0xFF1E293B);

  @override
  Color get surfaceElevated => const Color(0xFF334155);

  @override
  Color get neutralDivider => const Color(0xFF475569);

  @override
  Color get textPrimary => const Color(0xFFF8FAFC);

  @override
  Color get textSecondary => const Color(0xFFCBD5E1);

  @override
  Color get textTertiary => const Color(0xFF94A3B8);

  @override
  Color get textInverse =>
      // Inverse text for light/saturated surfaces.
      const Color(0xFF0B0F14);

  @override
  Color get feedbackSuccess => const Color(0xFF4ADE80);

  @override
  Color get feedbackWarning => const Color(0xFFFBBF24);

  @override
  Color get feedbackError => const Color(0xFFF87171);

  @override
  Color get feedbackInfo => const Color(0xFF818CF8);

  @override
  Color get stateActive =>
      // Intentionally aligned with brandPrimary dark value.
      // Semantic independence: stateActive communicates interaction feedback,
      // not brand identity.
      const Color(0xFFFB923C);

  @override
  Color get stateHover =>
      // Hover affordance is applicable on pointer platforms.
      const Color(0xFF334155);

  @override
  Color get stateDisabled => const Color(0xFF64748B);

  @override
  Color get stateFocus =>
      // Intentionally aligned with brandPrimary family.
      // Semantic independence: stateFocus communicates accessibility focus,
      // not branding.
      const Color(0xFFC2410C);

  @override
  Color get stateSelected =>
      // Intentionally aligned with brandPrimary family.
      // Semantic independence: stateSelected communicates persistent selection,
      // not branding.
      const Color(0xFFFDBA74);

  @override
  Color get overlayDark => const Color(0x7A000000);

  @override
  Color get overlayLight => const Color(0x1FFFFFFF);

  @override
  Color get scrim => const Color(0xB3000000);

  @override
  Color get skeleton => const Color(0xFF334155);

  @override
  Color get chartPrimary =>
      // Intentionally aligned with brandPrimary dark value.
      // Semantic independence: chartPrimary is for data emphasis, not branding.
      const Color(0xFFFB923C);

  @override
  Color get chartSecondary =>
      // Intentionally aligned with brandSecondary dark value.
      // Semantic independence: chartSecondary is for comparisons, not branding.
      const Color(0xFFF472B6);

  @override
  Color get chartTertiary =>
      // Intentionally aligned with brandAccent dark value.
      // Semantic independence: chartTertiary is for additional series, not branding.
      const Color(0xFF22D3EE);
}
