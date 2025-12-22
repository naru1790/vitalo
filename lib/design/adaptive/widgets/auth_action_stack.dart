import 'package:flutter/widgets.dart';

import '../platform/app_platform_scope.dart';
import 'auth_sign_in_button.dart';
import '../../tokens/spacing.dart';

/// Loading state for coordinated auth button behavior.
///
/// Only one authentication method can be in-progress at a time.
enum AuthLoadingState { none, apple, google }

/// A vertical stack of authentication action buttons.
///
/// Renders CTAs in priority order:
/// 1. Apple (iOS only)
/// 2. Google
/// 3. Email
///
/// Platform gating and loading coordination are owned by this widget.
/// Callers provide callbacks only — no layout or styling parameters.
///
/// Uses [AuthSignInButton] for each provider, enforcing semantic identity
/// and consistent branding across all authentication surfaces.
// @frozen
class AuthActionStack extends StatelessWidget {
  const AuthActionStack({
    super.key,
    required this.onApple,
    required this.onGoogle,
    required this.onEmail,
    required this.loadingState,
  });

  /// Called when Apple sign-in is tapped. Only invoked on iOS.
  final VoidCallback onApple;

  /// Called when Google sign-in is tapped.
  final VoidCallback onGoogle;

  /// Called when Email sign-in is tapped.
  final VoidCallback onEmail;

  /// Current loading state. Disables all buttons when any auth is in-progress.
  final AuthLoadingState loadingState;

  bool get _isLoading => loadingState != AuthLoadingState.none;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final spacing = Spacing.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Apple sign-in: iOS only, primary emphasis
        if (platform == AppPlatform.ios) ...[
          AuthSignInButton(
            provider: AuthProvider.apple,
            emphasis: AuthButtonEmphasis.primary,
            onPressed: onApple,
            enabled: !_isLoading,
            loading: loadingState == AuthLoadingState.apple,
          ),
          SizedBox(height: spacing.sm),
        ],

        // Google Sign-In button: secondary emphasis on iOS, primary on Android
        AuthSignInButton(
          provider: AuthProvider.google,
          emphasis: platform == AppPlatform.ios
              ? AuthButtonEmphasis.secondary
              : AuthButtonEmphasis.primary,
          onPressed: onGoogle,
          enabled: !_isLoading,
          loading: loadingState == AuthLoadingState.google,
        ),

        SizedBox(height: spacing.sm),

        // Email sign-in option: tertiary emphasis (ghost style)
        AuthSignInButton(
          provider: AuthProvider.email,
          emphasis: AuthButtonEmphasis.tertiary,
          onPressed: onEmail,
          enabled: !_isLoading,
        ),
      ],
    );
  }
}
