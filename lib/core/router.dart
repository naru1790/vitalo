import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../features/auth/presentation/email_signin_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/landing/presentation/landing_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const emailSignin = '/email-signin';
  static const dashboard = '/dashboard';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Smooth fade + slide transition for navigation
CustomTransitionPage<T> _buildSmoothTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  bool slideFromRight = true,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Smooth easing curve
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      // Fade transition
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(curvedAnimation);

      // Subtle slide transition
      final slideAnimation = Tween<Offset>(
        begin: Offset(slideFromRight ? 0.05 : -0.05, 0.0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: slideAnimation, child: child),
      );
    },
  );
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  observers: [_NavigationObserver()],
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => _buildSmoothTransition(
        context: context,
        state: state,
        child: const LandingScreen(),
        slideFromRight: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.emailSignin,
      name: 'emailSignin',
      pageBuilder: (context, state) => _buildSmoothTransition(
        context: context,
        state: state,
        child: const EmailSignInScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      pageBuilder: (context, state) => _buildSmoothTransition(
        context: context,
        state: state,
        child: const DashboardScreen(),
      ),
    ),
  ],
  redirect: (context, state) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
    final isProtectedRoute = state.matchedLocation == AppRoutes.dashboard;

    if (!isAuthenticated && isProtectedRoute) {
      talker.info(
        'Navigation redirect: Unauthenticated user blocked from ${state.matchedLocation}',
      );
      return AppRoutes.home;
    }
    return null;
  },
);

/// Navigation observer for tracking route changes
class _NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('pop', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && oldRoute != null) {
      talker.info(
        'Navigation: Replaced ${_getRouteName(oldRoute)} → ${_getRouteName(newRoute)}',
      );
    }
  }

  void _logNavigation(String action, Route route, Route? previousRoute) {
    final routeName = _getRouteName(route);
    if (previousRoute != null) {
      final prevName = _getRouteName(previousRoute);
      talker.info('Navigation: $action $routeName (from $prevName)');
    } else {
      talker.info('Navigation: $action $routeName');
    }
  }

  String _getRouteName(Route route) {
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      return route.settings.name!;
    }
    return route.toString();
  }
}
