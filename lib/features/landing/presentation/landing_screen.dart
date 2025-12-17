import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/social_sign_in_button.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/flux_mascot.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_snackbar.dart';

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
          const FluxMascot(size: 200),
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
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

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
      AppSnackBar.showError(context, error);
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
          SignInButton(
            onPressed: _isLoading ? null : _handleAppleSignIn,
            label: 'Continue with Apple',
            icon: const Icon(
              Icons.apple,
              color: Colors.white,
              size: AppSpacing.iconSize,
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            borderColor: Colors.black,
            isLoading: _loadingState == _LoadingState.apple,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Google Sign-In button
          SignInButton(
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            label: 'Continue with Google',
            icon: const SizedBox(
              width: AppSpacing.iconSizeSmall,
              height: AppSpacing.iconSizeSmall,
              child: GoogleLogo(),
            ),
            backgroundColor: theme.brightness == Brightness.dark
                ? const Color(0xFF131314)
                : Colors.white,
            foregroundColor: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1F1F1F),
            borderColor: theme.brightness == Brightness.dark
                ? const Color(0xFF8E918F)
                : colorScheme.outline,
            isLoading: _loadingState == _LoadingState.google,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Email sign-in option
          SignInButton(
            onPressed: _handleEmailFlow,
            label: 'Sign in with Email',
            icon: Icon(
              Icons.email_outlined,
              size: AppSpacing.iconSizeSmall,
              color: colorScheme.primary,
            ),
            isLoading: _isLoading,
          ),

          const Spacer(),

          const SizedBox(height: AppSpacing.md),

          // Footer with links
          Center(
            child: Text.rich(
              TextSpan(
                text: 'By continuing, you agree to our ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
                          const SizedBox(width: AppSpacing.xxs),
                          Icon(
                            Icons.open_in_new,
                            size: AppSpacing.sm,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ' & ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
                          const SizedBox(width: AppSpacing.xxs),
                          Icon(
                            Icons.open_in_new,
                            size: AppSpacing.sm,
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
