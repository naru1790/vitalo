// @frozen
// Tier-1 auth identity button.
// Owns: provider → label + icon mapping.
// Must NOT: expose child, leading, icon, label, or builder slots.

import 'package:flutter/widgets.dart';

import '../../tokens/icons.dart' as icons;
import 'app_button.dart';

/// Authentication provider identity.
///
/// Represents the identity provider, NOT the button style.
/// Each value maps to a fixed label and icon internally.
/// Feature code selects provider; AuthSignInButton resolves appearance.
enum AuthProvider {
  /// Google OAuth provider.
  google,

  /// Apple Sign In provider.
  apple,

  /// Email/password authentication.
  email,
}

/// Semantic emphasis for auth buttons.
///
/// Controls visual weight without exposing color or style.
/// Maps to AppButtonVariant internally.
enum AuthButtonEmphasis {
  /// High prominence — primary CTA.
  primary,

  /// Medium prominence — secondary option.
  secondary,

  /// Low prominence — tertiary/ghost action.
  tertiary,
}

/// Tier-1 auth identity button.
///
/// A semantic wrapper for authentication sign-in actions.
/// Internally composes [AppButton] — does NOT re-implement visuals.
///
/// ## Architectural Intent
///
/// This component enforces semantic correctness by API design:
/// - Provider identity maps to fixed label and icon internally
/// - Feature code cannot customize copy, icon, or layout
/// - All auth buttons share consistent branding across the app
///
/// ## Locked API
///
/// This component exposes ONLY:
/// - [provider]: Which auth method (Google, Apple, Email)
/// - [onPressed]: Callback invoked on tap
/// - [emphasis]: Visual weight (primary/secondary/tertiary)
/// - [enabled]: Whether interaction is allowed
/// - [loading]: Whether loading indicator is shown
///
/// It does NOT expose child, leading, icon, label, or builder slots.
/// Customization is intentionally impossible.
///
/// ## Usage
///
/// ```dart
/// AuthSignInButton(
///   provider: AuthProvider.google,
///   onPressed: () => authService.signInWithGoogle(),
/// )
/// ```
// @frozen
class AuthSignInButton extends StatelessWidget {
  const AuthSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.emphasis = AuthButtonEmphasis.primary,
    this.enabled = true,
    this.loading = false,
  });

  /// Authentication provider identity.
  /// Determines label text and leading icon internally.
  final AuthProvider provider;

  /// Callback invoked on tap.
  final VoidCallback onPressed;

  /// Visual emphasis level.
  final AuthButtonEmphasis emphasis;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether loading indicator is shown.
  final bool loading;

  /// Internal: Resolve provider to fixed label.
  /// Feature code MUST NOT influence this mapping.
  String get _label {
    return switch (provider) {
      AuthProvider.google => 'Continue with Google',
      AuthProvider.apple => 'Continue with Apple',
      AuthProvider.email => 'Continue with Email',
    };
  }

  /// Internal: Resolve provider to semantic icon.
  /// Feature code MUST NOT influence this mapping.
  icons.AppIcon get _icon {
    return switch (provider) {
      AuthProvider.google => icons.AppIcon.authGoogle,
      AuthProvider.apple => icons.AppIcon.authApple,
      AuthProvider.email => icons.AppIcon.authEmail,
    };
  }

  /// Internal: Map AuthButtonEmphasis to AppButtonVariant.
  AppButtonVariant get _variant {
    return switch (emphasis) {
      AuthButtonEmphasis.primary => AppButtonVariant.primary,
      AuthButtonEmphasis.secondary => AppButtonVariant.secondary,
      AuthButtonEmphasis.tertiary => AppButtonVariant.ghost,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Delegate entirely to AppButton with leadingIcon.
    // No platform branching, no color/motion/shape logic here.
    return AppButton(
      label: _label,
      leadingIcon: _icon,
      onPressed: onPressed,
      variant: _variant,
      enabled: enabled,
      loading: loading,
      semanticLabel: _label,
    );
  }
}
