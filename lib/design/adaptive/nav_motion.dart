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

/// Semantic navigation transition intent.
///
/// Routing declares intent; platform shells decide how it animates.
enum NavTransition { push, modal, peer }

/// Delegate that owns platform-specific navigation motion.
abstract class NavMotionDelegate {
  const NavMotionDelegate();

  Duration transitionDuration(BuildContext context, NavTransition intent);

  Duration reverseTransitionDuration(
    BuildContext context,
    NavTransition intent,
  );

  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    NavTransition intent,
  );
}

class NavMotionScope extends InheritedWidget {
  const NavMotionScope({
    super.key,
    required this.delegate,
    required super.child,
  });

  final NavMotionDelegate delegate;

  static NavMotionDelegate of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NavMotionScope>();

    assert(() {
      if (scope == null) {
        throw FlutterError.fromParts([
          ErrorSummary(
            'NavMotionScope is missing above the current Navigator.',
          ),
          ErrorDescription(
            'AdaptivePage requires a NavMotionDelegate provided by a platform shell.',
          ),
          ErrorHint(
            'Wrap your app content with NavMotionScope in the platform shell (e.g., IosShell/AndroidShell).',
          ),
        ]);
      }
      return true;
    }());

    return scope?.delegate ?? const _NoMotionDelegate();
  }

  @override
  bool updateShouldNotify(NavMotionScope oldWidget) {
    return oldWidget.delegate.runtimeType != delegate.runtimeType;
  }
}

class _NoMotionDelegate extends NavMotionDelegate {
  const _NoMotionDelegate();

  @override
  Duration transitionDuration(BuildContext context, NavTransition intent) {
    return Duration.zero;
  }

  @override
  Duration reverseTransitionDuration(
    BuildContext context,
    NavTransition intent,
  ) {
    return Duration.zero;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    NavTransition intent,
  ) {
    return child;
  }
}

/// Page wrapper that carries transition intent.
///
/// The actual animation is provided by [NavMotionScope] (shell-owned).
class AdaptivePage<T> extends Page<T> {
  const AdaptivePage({
    super.key,
    super.name,
    super.arguments,
    required this.child,
    required this.intent,
  });

  final Widget child;
  final NavTransition intent;

  @override
  Route<T> createRoute(BuildContext context) {
    final delegate = NavMotionScope.of(context);

    final Duration duration = delegate.transitionDuration(context, intent);
    final Duration reverseDuration = delegate.reverseTransitionDuration(
      context,
      intent,
    );

    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return delegate.buildTransitions(
          context,
          animation,
          secondaryAnimation,
          child,
          intent,
        );
      },
    );
  }
}
