import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:vitalo/features/landing/presentation/landing_screen.dart';
import 'package:vitalo/features/dashboard/presentation/dashboard_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/auth/onboarding',
      name: 'onboarding',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Health Assessment'),
    ),
    GoRoute(
      path: '/product-overview',
      name: 'productOverview',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Product Overview'),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
  redirect: (context, state) {
    final user = Supabase.instance.client.auth.currentUser;
    final isAuthenticated = user != null;

    final isDashboard = state.matchedLocation == '/dashboard';

    // If user is not authenticated and trying to access dashboard, redirect to landing
    if (!isAuthenticated && isDashboard) {
      return '/';
    }

    return null; // No redirect needed
  },
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen coming soon.',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
