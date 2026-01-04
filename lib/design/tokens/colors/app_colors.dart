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
  // Feedback roles are reserved for system/validation outcomes.
  // Use these when something failed or needs attention (e.g., form errors,
  // network failures, denied permissions).
  Color get feedbackSuccess;
  Color get feedbackWarning;

  // Reserved for system or validation failures.
  // MUST NOT be used to style intentional user actions.
  Color get feedbackError;
  Color get feedbackInfo;

  // Actions
  // Action roles are reserved for intentional, user-triggered intents.
  // They are not error states; they describe what the user is choosing to do.

  /// Intentional destructive action (e.g., sign out, delete).
  ///
  /// Semantics:
  /// - User-triggered
  /// - Potentially destructive
  /// - Not a system/validation error
  ///
  /// Must not reuse [feedbackError]. Palettes may derive from their red family,
  /// but the resulting color should be visually calmer than error states.
  Color get actionDestructive;

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
