import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

import '../../../main.dart';
import '../../../core/config.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/flux_mascot.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/vitalo_snackbar.dart';
import '../../../core/widgets/vitalo_captcha.dart';

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

enum _LoadingState { none, apple, google, guest }

class _ActionsSectionState extends State<_ActionsSection> {
  final _authService = AuthService();
  _LoadingState _loadingState = _LoadingState.none;
  bool get _isLoading => _loadingState != _LoadingState.none;

  // Pre-initialize captcha when screen loads for instant verification
  final GlobalKey<VitaloCaptchaState> _captchaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    talker.info('Landing screen actions section initialized');
    // Captcha now mounts immediately and initializes in background
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

    // Note: Captcha not supported for OAuth in current Supabase version
    final error = await authMethod();

    if (!mounted) return;
    setState(() => _loadingState = _LoadingState.none);

    if (error != null) {
      talker.warning('$provider OAuth failed: $error');
      VitaloSnackBar.showError(context, error);
    } else {
      talker.info('$provider OAuth successful, navigating to dashboard');
      context.go('/dashboard');
    }
  }

  Future<void> _handleAppleSignIn() =>
      _handleOAuth(_LoadingState.apple, _authService.signInWithApple, 'Apple');

  Future<void> _handleGoogleSignIn() => _handleOAuth(
    _LoadingState.google,
    _authService.signInWithGoogle,
    'Google',
  );

  Future<void> _handleGuestLogin() async {
    setState(() => _loadingState = _LoadingState.guest);

    talker.info('Guest login flow initiated');

    // Get fresh captcha token to prevent bot abuse and database bloat
    talker.debug('Requesting captcha token for guest login');
    final captchaToken = await _captchaKey.currentState?.verify();

    // SECURITY: Block login if captcha fails - prevents bot abuse
    if (captchaToken == null) {
      talker.warning('Captcha verification failed, blocking guest login');
      if (!mounted) return;
      setState(() => _loadingState = _LoadingState.none);
      VitaloSnackBar.showError(
        context,
        'Verification failed. Please try again.',
      );
      return;
    }

    talker.debug('Captcha token received, proceeding with anonymous sign-in');
    final error = await _authService.signInAnonymously(
      captchaToken: captchaToken,
    );

    if (!mounted) return;
    setState(() => _loadingState = _LoadingState.none);

    if (error != null) {
      // Network failure or other error - show retry option
      talker.warning('Guest login failed: $error');
      VitaloSnackBar.showError(context, error);
    } else {
      // Seamless transition to dashboard
      talker.info('Guest login successful, navigating to dashboard');
      context.go('/dashboard');
    }
  }

  void _handleEmailFlow() {
    if (_isLoading) return;
    talker.info('Email sign-in flow initiated from landing screen');
    context.push('/email-signin');
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Smart Auth: Show Apple button only on iOS
              if (isIOS) ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: SignInWithAppleButton(
                    onPressed: _isLoading ? () {} : _handleAppleSignIn,
                    style: SignInWithAppleButtonStyle.black,
                    text: _loadingState == _LoadingState.apple
                        ? 'Signing in...'
                        : 'Continue with Apple',
                  ),
                ),
                const SizedBox(height: 12),
              ],

              SizedBox(
                width: double.infinity,
                height: 54,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SignInButton(
                        Buttons.google,
                        text: 'Continue with Google',
                        onPressed: _isLoading ? () {} : _handleGoogleSignIn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: colorScheme.outline),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.all(1),
                      ),
                    ),
                    if (_loadingState == _LoadingState.google)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Guest login - Outlined button with accent border
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleGuestLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _loadingState == _LoadingState.guest
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        )
                      : Text(
                          'Continue as Guest',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const Spacer(),

              // Email login footer - Premium two-tone design
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleEmailFlow,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),

          // Pre-initialized Captcha - mounts on screen load for instant verification
          // Using Offstage instead of Positioned to avoid clipping issues
          Offstage(
            offstage: true,
            child: VitaloCaptcha(
              key: _captchaKey,
              siteKey: AppConfig.turnstileSiteKey,
              baseUrl: AppConfig.turnstileBaseUrl,
              options: TurnstileOptions(mode: TurnstileMode.invisible),
              onTokenReceived: (_) {},
              onError: (error) {
                VitaloSnackBar.showWarning(context, error);
              },
            ),
          ),
        ],
      ),
    );
  }
}
