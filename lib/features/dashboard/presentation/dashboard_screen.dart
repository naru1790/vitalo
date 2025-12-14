import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    talker.info('Dashboard screen opened');
  }

  @override
  void dispose() {
    talker.debug('Dashboard screen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              talker.info('Sign out initiated from dashboard');
              final error = await _authService.signOut();
              if (error != null && context.mounted) {
                talker.warning('Sign out failed: $error');
                VitaloSnackBar.showError(context, error);
              } else if (context.mounted) {
                talker.info('Sign out successful, navigating to landing');
                context.go(AppRoutes.home);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Vitalo!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (user?.email != null)
              Text(user!.email!, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            const Text('Dashboard coming soon...'),
          ],
        ),
      ),
    );
  }
}
