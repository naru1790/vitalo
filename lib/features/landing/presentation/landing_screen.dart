import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sign_in_button/sign_in_button.dart';

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

enum _LoadingState { none, apple, google, guest }

class _ActionsSectionState extends State<_ActionsSection> {
  final _authService = AuthService();
  _LoadingState _loadingState = _LoadingState.none;

  bool get _isLoading => _loadingState != _LoadingState.none;

  Future<void> _handleOAuth(
    _LoadingState loadingState,
    Future<String?> Function() authMethod,
  ) async {
    setState(() => _loadingState = loadingState);

    final error = await authMethod();

    if (!mounted) return;
    setState(() => _loadingState = _LoadingState.none);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _handleAppleSignIn() =>
      _handleOAuth(_LoadingState.apple, _authService.signInWithApple);

  Future<void> _handleGoogleSignIn() =>
      _handleOAuth(_LoadingState.google, _authService.signInWithGoogle);

  Future<void> _handleGuestLogin() async {
    setState(() => _loadingState = _LoadingState.guest);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.go('/dashboard');
  }

  void _handleEmailFlow() {
    if (_isLoading) return;
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
      child: Column(
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
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.all(1),
                  ),
                ),
                if (_loadingState == _LoadingState.google)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
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

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleGuestLogin,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
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
                        color: Colors.grey.shade700,
                      ),
                    )
                  : Text(
                      'Continue as Guest',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
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
                    color: Colors.grey[600],
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
    );
  }
}
