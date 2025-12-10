import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vitalo/features/landing/presentation/landing_screen.dart';
import 'package:vitalo/features/auth/presentation/signup_screen.dart';
import 'package:vitalo/features/auth/presentation/login_screen.dart';

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
      path: '/auth/signup',
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/auth/onboarding',
      name: 'onboarding',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Health Assessment'),
    ),
    GoRoute(
      path: '/auth/login',
      name: 'signin',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/product-overview',
      name: 'productOverview',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Product Overview'),
    ),
    // TODO: Add dashboard and other protected routes when Supabase authentication is integrated.
  ],
  redirect: (context, state) {
    // TODO: Wire up Supabase session-based redirects.
    return null;
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
