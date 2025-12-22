import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../design/adaptive/widgets/app_scaffold.dart';
import '../../../design/adaptive/widgets/app_text.dart';
import '../../../design/adaptive/widgets/auth_action_stack.dart';
import '../../../design/adaptive/widgets/auth_footer_links.dart';
import '../../../design/tokens/spacing.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/flux_mascot.dart';
import '../../../main.dart';

// @frozen
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: AppSafeArea.all,
      body: Column(
        children: [
          // Top Section: Brand Hook (flexible, scroll-safe)
          const Flexible(child: _BrandHookSection()),

          // Bottom Section: Actions (bottom-anchored)
          const _ActionsSection(),
        ],
      ),
    );
  }
}

class _BrandHookSection extends StatelessWidget {
  const _BrandHookSection();

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FluxMascot(size: 200),
              SizedBox(height: spacing.xl),
              // App name uses display variant for hero moment.
              const AppText(
                'Vitalo',
                variant: AppTextVariant.display,
                align: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              // Tagline uses title variant for section heading.
              const AppText(
                'Awaken Your Intelligent Wellness',
                variant: AppTextVariant.title,
                maxLines: 2,
                align: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              // Description uses body variant for primary reading text.
              const AppText(
                'Vitalo learns and grows with you — mind, body, and beyond.',
                variant: AppTextVariant.body,
                color: AppTextColor.secondary,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsSection extends StatefulWidget {
  const _ActionsSection();

  @override
  State<_ActionsSection> createState() => _ActionsSectionState();
}

class _ActionsSectionState extends State<_ActionsSection> {
  final _authService = AuthService();
  AuthLoadingState _loadingState = AuthLoadingState.none;
  bool get _isLoading => _loadingState != AuthLoadingState.none;

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
    AuthLoadingState loadingState,
    Future<String?> Function() authMethod,
    String provider,
  ) async {
    talker.info('$provider OAuth sign-in initiated');
    setState(() => _loadingState = loadingState);

    final error = await authMethod();

    if (!mounted) return;
    setState(() => _loadingState = AuthLoadingState.none);

    if (error != null) {
      talker.warning('$provider OAuth failed: $error');
      AppSnackBar.showError(context, error);
    } else {
      talker.info('$provider OAuth successful, navigating to dashboard');
      context.go(AppRoutes.dashboard);
    }
  }

  Future<void> _handleAppleSignIn() => _handleOAuth(
    AuthLoadingState.apple,
    _authService.signInWithApple,
    'Apple',
  );

  Future<void> _handleGoogleSignIn() => _handleOAuth(
    AuthLoadingState.google,
    _authService.signInWithGoogle,
    'Google',
  );

  void _handleEmailFlow() {
    if (_isLoading) return;
    talker.info('Email sign-in flow initiated from landing screen');
    context.push(AppRoutes.emailSignin);
  }

  void _handleTermsTap() {
    talker.info('Terms of Service link tapped');
    context.push(AppRoutes.terms);
  }

  void _handlePrivacyTap() {
    talker.info('Privacy Policy link tapped');
    context.push(AppRoutes.privacy);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthActionStack(
            onApple: _handleAppleSignIn,
            onGoogle: _handleGoogleSignIn,
            onEmail: _handleEmailFlow,
            loadingState: _loadingState,
          ),

          SizedBox(height: spacing.xl),

          AuthFooterLinks(
            onTerms: _handleTermsTap,
            onPrivacy: _handlePrivacyTap,
          ),
        ],
      ),
    );
  }
}
