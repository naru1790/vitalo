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

import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';
import 'nav_motion.dart';

class IosNavMotionDelegate extends NavMotionDelegate {
  const IosNavMotionDelegate();

  @override
  Duration transitionDuration(BuildContext context, NavTransition intent) {
    if (_reducedMotionOf(context)) return Duration.zero;
    final motion = AppMotionTokens.of;
    switch (intent) {
      case NavTransition.modal:
        return motion.slow;
      case NavTransition.push:
      case NavTransition.peer:
        return motion.normal;
    }
  }

  @override
  Duration reverseTransitionDuration(
    BuildContext context,
    NavTransition intent,
  ) {
    if (_reducedMotionOf(context)) return Duration.zero;
    final motion = AppMotionTokens.of;
    switch (intent) {
      case NavTransition.modal:
        return motion.normal;
      case NavTransition.push:
      case NavTransition.peer:
        return motion.fast;
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    NavTransition intent,
  ) {
    if (_reducedMotionOf(context)) return child;

    final motion = AppMotionTokens.of;
    final Curve curve = intent == NavTransition.peer
        ? motion.easeInOut
        : motion.easeOut;
    final Curve reverseCurve = intent == NavTransition.peer
        ? motion.easeInOut
        : motion.easeIn;

    final curved = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    switch (intent) {
      case NavTransition.modal:
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      case NavTransition.push:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.25, 0.0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      case NavTransition.peer:
        return FadeTransition(opacity: curved, child: child);
    }
  }

  static bool _reducedMotionOf(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) return false;
    return mq.disableAnimations || mq.accessibleNavigation;
  }
}
