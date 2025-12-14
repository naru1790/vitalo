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

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  observers: [_NavigationObserver()],
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (_, __) => const LandingScreen(),
    ),
    GoRoute(
      path: AppRoutes.emailSignin,
      name: 'emailSignin',
      builder: (_, __) => const EmailSignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (_, __) => const DashboardScreen(),
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
