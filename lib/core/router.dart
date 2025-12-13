import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      return AppRoutes.home;
    }
    return null;
  },
);
