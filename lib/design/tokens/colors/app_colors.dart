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

/// Semantic color contract.
///
/// This interface defines meaning (roles), not palettes or themes.
/// Concrete implementations are parallel interpretations (light vs dark)
/// and platform interpretations (iOS vs Android).
abstract class AppColors {
  const AppColors();

  // Brand
  Color get brandPrimary;
  Color get brandSecondary;
  Color get brandAccent;
  Color get brandSurface;

  // Neutrals
  Color get neutralBase;
  Color get neutralSurface;
  Color get surfaceElevated;
  Color get neutralDivider;
  Color get surfaceBorder;

  // Text
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;
  Color get textInverse;

  // Feedback
  Color get feedbackSuccess;
  Color get feedbackWarning;
  Color get feedbackError;
  Color get feedbackInfo;

  // Interactive States
  Color get stateActive;
  Color get stateHover;
  Color get stateDisabled;
  Color get stateFocus;
  Color get stateSelected;

  // Controls (mechanical)
  // These roles are for control mechanics (switches, checkboxes, sliders).
  // They MUST NOT reuse text* or state* semantics at call sites.
  Color get controlActive;
  Color get controlOnInverse;

  // Overlays
  Color get overlayDark;
  Color get overlayLight;
  Color get scrim;
  Color get skeleton;

  // Data Visualization
  Color get chartPrimary;
  Color get chartSecondary;
  Color get chartTertiary;
}
