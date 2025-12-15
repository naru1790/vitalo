import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/social_sign_in_button.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/flux_mascot.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

/// Landing Page - "Soft Gateway" for Vitalo
/// Top 60%: Brand Hook (logo, mascot, slogan)
/// Bottom 40%: Hierarchical login actions
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Brand Hook (~60% of screen)
            Expanded(flex: 6, child: BrandHookSection()),

            // Bottom Section: Actions (~40% of screen)
            Expanded(flex: 4, child: _ActionsSection()),
          ],
        ),
      ),
    );
  }
}

/// Placeholder widget for the Brand Hook section.
/// Contains logo, mascot, and slogan - DO NOT MODIFY alignment/design.
class BrandHookSection extends StatelessWidget {
  const BrandHookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FluxMascot(size: 200, themeMode: Theme.of(context).brightness),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Vitalo',
            style: theme.textTheme.displayLarge?.copyWith(
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Awaken Your Intelligent Wellness',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Vitalo learns and grows with you — mind, body, and beyond.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Bottom section with hierarchical login actions
class _ActionsSection extends StatefulWidget {
  const _ActionsSection();

  @override
  State<_ActionsSection> createState() => _ActionsSectionState();
}

enum _LoadingState { none, apple, google }

class _ActionsSectionState extends State<_ActionsSection> {
  final _authService = AuthService();
  _LoadingState _loadingState = _LoadingState.none;
  bool get _isLoading => _loadingState != _LoadingState.none;

  @override
  void initState() {
    super.initState();
    talker.info('Landing screen actions section initialized');
  }

  @override
  void dispose() {
    talker.debug('Landing screen actions section disposed');
    super.dispose();
  }

  Future<void> _handleOAuth(
    _LoadingState loadingState,
    Future<String?> Function() authMethod,
    String provider,
  ) async {
    talker.info('$provider OAuth sign-in initiated');
    setState(() => _loadingState = loadingState);

    final error = await authMethod();

    if (!mounted) return;
    setState(() => _loadingState = _LoadingState.none);

    if (error != null) {
      talker.warning('$provider OAuth failed: $error');
      VitaloSnackBar.showError(context, error);
    } else {
      talker.info('$provider OAuth successful, navigating to dashboard');
      context.go(AppRoutes.dashboard);
    }
  }

  Future<void> _handleAppleSignIn() =>
      _handleOAuth(_LoadingState.apple, _authService.signInWithApple, 'Apple');

  Future<void> _handleGoogleSignIn() => _handleOAuth(
    _LoadingState.google,
    _authService.signInWithGoogle,
    'Google',
  );

  void _handleEmailFlow() {
    if (_isLoading) return;
    talker.info('Email sign-in flow initiated from landing screen');
    context.push(AppRoutes.emailSignin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIOS = Platform.isIOS;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontalPadding,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Smart Auth: Show Apple button only on iOS (temporarily shown on all platforms for testing)
          // TODO: Restore `if (isIOS)` check before production
          SocialSignInButton(
            provider: SocialProvider.apple,
            onPressed: _isLoading ? null : _handleAppleSignIn,
            isLoading: _loadingState == _LoadingState.apple,
          ),
          const SizedBox(height: 12),

          // Google Sign-In button
          SocialSignInButton(
            provider: SocialProvider.google,
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            isLoading: _loadingState == _LoadingState.google,
          ),

          const SizedBox(height: 12),

          // Email sign-in option
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleEmailFlow,
              icon: Icon(
                Icons.email_outlined,
                size: 18,
                color: colorScheme.onSurface,
              ),
              label: Text(
                'Sign in with Email',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const Spacer(),

          const SizedBox(height: AppSpacing.md),

          // Footer with links
          Center(
            child: Text.rich(
              TextSpan(
                text: 'By continuing, you agree to our ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        talker.info('Terms of Service link tapped');
                        context.push(AppRoutes.terms);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Terms',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.open_in_new,
                            size: 12,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ' & ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        talker.info('Privacy Policy link tapped');
                        context.push(AppRoutes.privacy);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.open_in_new,
                            size: 12,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
