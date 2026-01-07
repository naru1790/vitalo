// @frozen
// Semantic feedback timing tokens.
//
// Purpose:
// - Feedback timing describes PRESENCE duration (how long something stays visible).
// - Motion timing describes MOVEMENT duration (how long something animates).
//
// Architectural rule:
// - Feature and adaptive UI code must not directly couple feedback duration to
//   motion tokens.
// - This abstraction may map to motion tokens internally today, but the
//   semantic boundary stays future-proof.

import 'motion.dart';

abstract final class AppFeedbackTiming {
  AppFeedbackTiming._();

  /// How long transient ERROR feedback remains visible.
  ///
  /// NOTE: This is not an animation duration.
  static Duration get errorDisplay => AppMotionTokens.of.normal;
}
