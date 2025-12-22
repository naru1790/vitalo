import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';
import 'app_icon.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════
//
// Design decision:
// AuthSignInButton prioritizes native platform look & feel.
// Semantics are universal; rendering uses native platform buttons.
// Visual parity across platforms is intentionally NOT enforced.
//
// Emphasis mapping:
// ┌───────────┬─────────────────────────┬──────────────────────────┐
// │ Emphasis  │ iOS                     │ Android                  │
// ├───────────┼─────────────────────────┼──────────────────────────┤
// │ primary   │ CupertinoButton.filled  │ FilledButton             │
// │ secondary │ CupertinoButton         │ FilledButton.tonal       │
// │ tertiary  │ CupertinoButton (text)  │ TextButton               │
// └───────────┴─────────────────────────┴──────────────────────────┘
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
/// Platform rendering determines actual appearance.
enum AuthButtonEmphasis {
  /// High prominence — primary CTA.
  /// iOS: CupertinoButton.filled | Android: FilledButton
  primary,

  /// Medium prominence — secondary option.
  /// iOS: CupertinoButton | Android: FilledButton.tonal
  secondary,

  /// Low prominence — tertiary/ghost action.
  /// iOS: CupertinoButton (text) | Android: TextButton
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

/// Minimum button height for accessibility (WCAG/Apple/Material ≥ 44dp).
const double _kMinButtonHeight = 48.0;

/// iOS implementation using native Cupertino buttons.
///
/// Uses CupertinoButton variants to ensure native iOS feel:
/// - Press feedback is opacity-based (built into CupertinoButton)
/// - No custom animations or color transitions
/// - Text styling delegated to Cupertino conventions
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

  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final spacing = Spacing.of;

    // Build content row (icon + label or loader).
    final content = _buildContent(context, theme, spacing);

    // Dispatch to appropriate native button based on emphasis.
    return switch (emphasis) {
      AuthButtonEmphasis.primary => _buildFilledButton(context, content),
      AuthButtonEmphasis.secondary => _buildTonalButton(context, content),
      AuthButtonEmphasis.tertiary => _buildTextButton(context, content),
    };
  }

  /// Primary: CupertinoButton.filled — prominent filled style.
  Widget _buildFilledButton(BuildContext context, Widget content) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  /// Secondary: CupertinoButton with gray background — less prominent.
  Widget _buildTonalButton(BuildContext context, Widget content) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: CupertinoColors.systemGrey5.resolveFrom(context),
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  /// Tertiary: CupertinoButton borderless — minimal emphasis.
  Widget _buildTextButton(BuildContext context, Widget content) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CupertinoThemeData theme,
    AppSpacing spacing,
  ) {
    if (loading) {
      // Loader replaces content; CupertinoButton provides size stability.
      // No color override — CupertinoActivityIndicator uses system default.
      return const CupertinoActivityIndicator();
    }

    // CupertinoButton applies DefaultTextStyle with correct foreground.
    // Read that color for the icon to match the text.
    return Builder(
      builder: (context) {
        final inheritedColor = DefaultTextStyle.of(context).style.color;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppIcon is the only legal icon renderer.
            // Color inherited from CupertinoButton's DefaultTextStyle.
            AppIcon(
              icon,
              size: AppIconSize.small,
              colorOverride: inheritedColor,
            ),
            SizedBox(width: spacing.sm),
            // No styling — CupertinoButton provides text style.
            Text(label),
          ],
        );
      },
    );
  }
}

/// Android implementation using native Material buttons.
///
/// Uses Material button variants to ensure native Android feel:
/// - Ripple and elevation handled by Material
/// - No custom InkWell or animation wrappers
/// - State transitions delegated to Material conventions
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

  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = Spacing.of;

    // Build content row (icon + label or loader).
    final content = _buildContent(context, theme, colorScheme, spacing);

    // Dispatch to appropriate native button based on emphasis.
    return switch (emphasis) {
      AuthButtonEmphasis.primary => _buildFilledButton(
        context,
        colorScheme,
        content,
      ),
      AuthButtonEmphasis.secondary => _buildTonalButton(
        context,
        colorScheme,
        content,
      ),
      AuthButtonEmphasis.tertiary => _buildTextButton(
        context,
        colorScheme,
        content,
      ),
    };
  }

  /// Primary: FilledButton — prominent filled style.
  Widget _buildFilledButton(
    BuildContext context,
    ColorScheme colorScheme,
    Widget content,
  ) {
    return SizedBox(
      width: double.infinity,
      height: _kMinButtonHeight,
      child: FilledButton(
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  /// Secondary: FilledButton.tonal — less prominent, tonal surface.
  Widget _buildTonalButton(
    BuildContext context,
    ColorScheme colorScheme,
    Widget content,
  ) {
    return SizedBox(
      width: double.infinity,
      height: _kMinButtonHeight,
      child: FilledButton.tonal(
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  /// Tertiary: TextButton — minimal emphasis, no background.
  Widget _buildTextButton(
    BuildContext context,
    ColorScheme colorScheme,
    Widget content,
  ) {
    return SizedBox(
      width: double.infinity,
      height: _kMinButtonHeight,
      child: TextButton(
        onPressed: _isInteractive ? onPressed : null,
        child: content,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppSpacing spacing,
  ) {
    if (loading) {
      // Loader replaces content; SizedBox wrapper provides size stability.
      // No color override — Material button provides foreground via IconTheme.
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    // Material buttons set IconTheme for their children.
    // Read that color for AppIcon to match button foreground.
    return Builder(
      builder: (context) {
        final inheritedColor = IconTheme.of(context).color;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppIcon is the only legal icon renderer.
            // Color inherited from Material button's IconTheme.
            AppIcon(
              icon,
              size: AppIconSize.small,
              colorOverride: inheritedColor,
            ),
            SizedBox(width: spacing.sm),
            // No styling — Material button provides text style.
            Text(label),
          ],
        );
      },
    );
  }
}
