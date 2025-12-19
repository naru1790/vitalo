import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../design/adaptive/nav_motion.dart';
import '../features/auth/presentation/email_signin_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/landing/presentation/landing_screen.dart';
import '../features/legal/presentation/privacy_policy_screen.dart';
import '../features/legal/presentation/terms_of_service_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const emailSignin = '/email-signin';
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const privacy = '/privacy';
  static const terms = '/terms';
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
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const LandingScreen(),
        intent: NavTransition.peer,
      ),
    ),
    GoRoute(
      path: AppRoutes.emailSignin,
      name: 'emailSignin',
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const EmailSignInScreen(),
        intent: NavTransition.push,
      ),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const DashboardScreen(),
        intent: NavTransition.peer,
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const ProfileScreen(),
        intent: NavTransition.push,
      ),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      name: 'privacy',
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const PrivacyPolicyScreen(),
        intent: NavTransition.modal,
      ),
    ),
    GoRoute(
      path: AppRoutes.terms,
      name: 'terms',
      pageBuilder: (context, state) => AdaptivePage<void>(
        key: state.pageKey,
        child: const TermsOfServiceScreen(),
        intent: NavTransition.modal,
      ),
    ),
  ],
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;
    final isAuthenticated = session != null;

    talker.debug(
      'Router redirect check: path=${state.matchedLocation}, '
      'session=${session != null}, user=${user?.email ?? "null"}',
    );

    final isOnLandingOrAuth =
        state.matchedLocation == AppRoutes.home ||
        state.matchedLocation == AppRoutes.emailSignin;
    final isProtectedRoute =
        state.matchedLocation == AppRoutes.dashboard ||
        state.matchedLocation == AppRoutes.profile;

    if (isAuthenticated && isOnLandingOrAuth) {
      talker.info(
        'Navigation redirect: Authenticated user redirected to dashboard',
      );
      return AppRoutes.dashboard;
    }

    if (!isAuthenticated && isProtectedRoute) {
      talker.info(
        'Navigation redirect: Unauthenticated user blocked from ${state.matchedLocation}',
      );
      return AppRoutes.home;
    }

    return null;
  },
);

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
