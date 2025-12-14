import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final isGuest = authService.isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: Text(isGuest ? 'Dashboard (Guest)' : 'Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final error = await authService.signOut();
              if (error != null && context.mounted) {
                VitaloSnackBar.showError(context, error);
              } else if (context.mounted) {
                context.go('/');
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
              isGuest ? 'Welcome, Guest!' : 'Welcome to Vitalo!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (user?.email != null)
              Text(user!.email!, style: Theme.of(context).textTheme.bodyLarge),
            if (isGuest)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSecondaryContainer
                      : AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSecondary
                        : AppColors.secondary,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkOnSecondaryContainer
                          : AppColors.onSecondaryContainer,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Temporary Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkOnSecondaryContainer
                            : AppColors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your progress won\'t be saved if you uninstall the app. Sign in to secure your data.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkOnSecondaryContainer
                            : AppColors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.push('/email-signin'),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkOnSecondaryContainer
                            : AppColors.onSecondaryContainer,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkOnSecondaryContainer.withValues(
                                alpha: 0.2,
                              )
                            : AppColors.onSecondaryContainer.withValues(
                                alpha: 0.15,
                              ),
                      ),
                      child: const Text(
                        'Assign Identity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            const Text('Dashboard coming soon...'),
          ],
        ),
      ),
    );
  }
}
