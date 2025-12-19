import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';
import 'nav_motion.dart';

class AndroidNavMotionDelegate extends NavMotionDelegate {
  const AndroidNavMotionDelegate();

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

    switch (intent) {
      case NavTransition.modal:
        final slide = CurvedAnimation(
          parent: animation,
          curve: motion.easeOut,
          reverseCurve: motion.easeIn,
        );

        final fade = CurvedAnimation(
          parent: animation,
          curve: motion.snap,
          reverseCurve: motion.snap,
        );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.12),
              end: Offset.zero,
            ).animate(slide),
            child: child,
          ),
        );
      case NavTransition.push:
        final slide = CurvedAnimation(
          parent: animation,
          curve: motion.easeOut,
          reverseCurve: motion.easeIn,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.12, 0.0),
            end: Offset.zero,
          ).animate(slide),
          child: child,
        );
      case NavTransition.peer:
        final fade = CurvedAnimation(
          parent: animation,
          curve: motion.easeInOut,
          reverseCurve: motion.easeInOut,
        );

        return FadeTransition(opacity: fade, child: child);
    }
  }

  static bool _reducedMotionOf(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) return false;
    return mq.disableAnimations || mq.accessibleNavigation;
  }
}
