import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/motion.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

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
/// A dedicated component for authentication sign-in actions.
/// This is NOT a variant of AppButton — it exists specifically for
/// authentication identity actions.
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
    switch (provider) {
      case AuthProvider.google:
        return 'Continue with Google';
      case AuthProvider.apple:
        return 'Continue with Apple';
      case AuthProvider.email:
        return 'Continue with Email';
    }
  }

  /// Internal: Resolve provider to semantic icon.
  /// Feature code MUST NOT influence this mapping.
  icons.AppIcon get _icon {
    switch (provider) {
      case AuthProvider.google:
        return icons.AppIcon.authGoogle;
      case AuthProvider.apple:
        return icons.AppIcon.authApple;
      case AuthProvider.email:
        return icons.AppIcon.authEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _CupertinoAuthButton(
        label: _label,
        icon: _icon,
        onPressed: onPressed,
        emphasis: emphasis,
        enabled: enabled,
        loading: loading,
      );
    }

    return _MaterialAuthButton(
      label: _label,
      icon: _icon,
      onPressed: onPressed,
      emphasis: emphasis,
      enabled: enabled,
      loading: loading,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE IMPLEMENTATIONS
// ═══════════════════════════════════════════════════════════════════════════

class _CupertinoAuthButton extends StatelessWidget {
  const _CupertinoAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.emphasis,
    required this.enabled,
    required this.loading,
  });

  final String label;
  final icons.AppIcon icon;
  final VoidCallback onPressed;
  final AuthButtonEmphasis emphasis;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;
    final motion = AppMotionTokens.of;

    final isInteractive = enabled && !loading;

    // Resolve colors based on emphasis
    final Color backgroundColor;
    final Color foregroundColor;

    switch (emphasis) {
      case AuthButtonEmphasis.primary:
        backgroundColor = theme.primaryColor;
        foregroundColor = CupertinoColors.white;
      case AuthButtonEmphasis.secondary:
        backgroundColor = CupertinoColors.systemGrey5.resolveFrom(context);
        foregroundColor =
            theme.textTheme.textStyle.color ?? CupertinoColors.label;
      case AuthButtonEmphasis.tertiary:
        backgroundColor = CupertinoColors.transparent;
        foregroundColor = theme.primaryColor;
    }

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: label,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isInteractive ? onPressed : null,
        child: AnimatedContainer(
          duration: motion.fast,
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(minHeight: 50),
          decoration: BoxDecoration(
            color: isInteractive
                ? backgroundColor
                : backgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(shape.full),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (loading)
                CupertinoActivityIndicator(color: foregroundColor)
              else ...[
                Icon(
                  icons.AppIcons.resolve(icon),
                  size: 20,
                  color: isInteractive
                      ? foregroundColor
                      : foregroundColor.withValues(alpha: 0.5),
                ),
                SizedBox(width: spacing.sm),
                Text(
                  label,
                  style: theme.textTheme.textStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isInteractive
                        ? foregroundColor
                        : foregroundColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialAuthButton extends StatelessWidget {
  const _MaterialAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.emphasis,
    required this.enabled,
    required this.loading,
  });

  final String label;
  final icons.AppIcon icon;
  final VoidCallback onPressed;
  final AuthButtonEmphasis emphasis;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;
    final motion = AppMotionTokens.of;

    final isInteractive = enabled && !loading;

    // Resolve colors based on emphasis
    final Color backgroundColor;
    final Color foregroundColor;

    switch (emphasis) {
      case AuthButtonEmphasis.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
      case AuthButtonEmphasis.secondary:
        backgroundColor = colorScheme.surfaceContainerHighest;
        foregroundColor = colorScheme.onSurface;
      case AuthButtonEmphasis.tertiary:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
    }

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInteractive ? onPressed : null,
          borderRadius: BorderRadius.circular(shape.full),
          child: AnimatedContainer(
            duration: motion.fast,
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              color: isInteractive
                  ? backgroundColor
                  : backgroundColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(shape.full),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (loading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foregroundColor,
                    ),
                  )
                else ...[
                  Icon(
                    icons.AppIcons.resolve(icon),
                    size: 20,
                    color: isInteractive
                        ? foregroundColor
                        : foregroundColor.withValues(alpha: 0.5),
                  ),
                  SizedBox(width: spacing.sm),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isInteractive
                          ? foregroundColor
                          : foregroundColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
