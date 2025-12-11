import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/flux_mascot.dart';
import '../../../core/widgets/vitalo_button.dart';

/// Minimal premium landing experience for first-time visitors.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    _checkReturningUser();
  }

  Future<void> _checkReturningUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLoggedIn = prefs.getBool('has_logged_in') ?? false;
      final skipRedirect = prefs.getBool('skip_redirect') ?? false;

      // Clear skip_redirect flag after checking it
      if (skipRedirect) {
        await prefs.remove('skip_redirect');
      }

      // If user has previously logged in and hasn't manually navigated back, redirect to login page
      if (hasLoggedIn && !skipRedirect && mounted) {
        // Small delay to prevent jarring transition
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          context.go('/auth/login');
        }
      }
    } catch (e) {
      // Silently fail - not critical
      debugPrint('Failed to check returning user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const verticalPadding = AppSpacing.giant;
            final double minHeight = constraints.maxHeight.isFinite
                ? (constraints.maxHeight - verticalPadding)
                      .clamp(0.0, double.infinity)
                      .toDouble()
                : 0.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontalPadding,
                  vertical: AppSpacing.pageVerticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                    minHeight: minHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacing.huge),
                        FluxMascot(
                          size: 220,
                          themeMode: Theme.of(context).brightness,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          'Vitalo',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Awaken Your Intelligent Wellness',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Vitalo learns and grows with you — mind, body, and beyond.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.massive),
                        _PrimaryActions(colorScheme: colorScheme),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitaloPrimaryButton(
          onPressed: () => context.go('/auth/signup'),
          label: 'Initiate My Vital Plan',
        ),
        const SizedBox(height: AppSpacing.md),
        VitaloSecondaryButton(
          onPressed: () => context.go('/auth/login'),
          label: 'I Already Have Momentum',
        ),
      ],
    );
  }
}
