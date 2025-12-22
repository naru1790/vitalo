import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/motion.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import 'app_text.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic button variants.
///
/// Each variant maps to shell-injected theme colors.
/// AppButton reads these; it does not resolve tokens.
enum AppButtonVariant {
  /// Prominent brand action. Primary CTA.
  primary,

  /// Neutral supporting action.
  secondary,

  /// Error/destructive intent. Deletion, logout, cancel.
  destructive,

  /// Borderless, low-emphasis action.
  ghost,
}

/// Tier-0/1 adaptive button primitive.
///
/// The only legal way to render text-based actions in feature code.
/// Enforces semantic variants, platform-correct feedback, and accessibility.
///
/// Feature code MUST use this instead of:
/// - [ElevatedButton]
/// - [TextButton]
/// - [OutlinedButton]
/// - [CupertinoButton]
/// - [InkWell] / [GestureDetector]
///
/// ## Responsibility Boundaries
///
/// This widget handles:
/// - Text-based action interaction
/// - Platform-appropriate feedback (ripple on Android, opacity on iOS)
/// - Disabled and loading state management
/// - Minimum touch target sizing
///
/// This widget does **NOT** handle:
/// - Icons (use [AppIconButton] for icon-only actions)
/// - Custom sizes or padding
/// - Hover or focus states
///
/// For icon-only actions, use [AppIconButton].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.enabled = true,
    this.loading = false,
    this.semanticLabel,
  });

  /// Button label text.
  final String label;

  /// Callback invoked on tap.
  ///
  /// Non-nullable by contract: disabled behavior is controlled solely via
  /// [enabled] and [loading]. This prevents ambiguous double-disabled states.
  final VoidCallback onPressed;

  /// Semantic variant controlling colors and emphasis.
  final AppButtonVariant variant;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether the button shows a loading indicator.
  /// When true, interaction is disabled and label is replaced with loader.
  final bool loading;

  /// Accessibility label for screen readers.
  /// Overrides visible label when provided.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _CupertinoButton(
        label: label,
        onPressed: onPressed,
        variant: variant,
        enabled: enabled,
        loading: loading,
        semanticLabel: semanticLabel,
      );
    }

    return _MaterialButton(
      label: label,
      onPressed: onPressed,
      variant: variant,
      enabled: enabled,
      loading: loading,
      semanticLabel: semanticLabel,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE IMPLEMENTATIONS
// ═══════════════════════════════════════════════════════════════════════════

/// Minimum button height.
///
/// This is a frozen constant (48.0px), not derived from spacing tokens.
/// Rationale: Touch targets require >= 44px per WCAG/Apple/Material guidelines.
/// 48px provides comfortable margin and aligns with Material component sizing.
/// This value is intentionally fixed to ensure consistent button sizing across
/// all variants and contexts.
const double _kMinButtonHeight = 48.0;

/// Material implementation with ink ripple feedback.
class _MaterialButton extends StatelessWidget {
  const _MaterialButton({
    required this.label,
    required this.onPressed,
    required this.variant,
    required this.enabled,
    required this.loading,
    required this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool enabled;
  final bool loading;
  final String? semanticLabel;

  /// Contract: interaction enabled only if enabled == true && loading == false.
  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Resolve colors from shell-injected theme based on variant.
    final colors = _resolveMaterialColors(colorScheme);

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: semanticLabel ?? label,
      child: AnimatedOpacity(
        // Contract: disabled visual treatment is opacity ONLY.
        opacity: _isInteractive ? 1.0 : 0.38,
        duration: motion.fast,
        curve: motion.easeOut,
        child: Material(
          color: colors.background,
          borderRadius: BorderRadius.circular(shape.md),
          child: InkWell(
            onTap: _isInteractive ? onPressed : null,
            borderRadius: BorderRadius.circular(shape.md),
            // Ghost variant uses minimal feedback; others use standard splash.
            splashColor: variant == AppButtonVariant.ghost
                ? colors.foreground.withValues(alpha: 0.04)
                : colors.foreground.withValues(alpha: 0.12),
            highlightColor: variant == AppButtonVariant.ghost
                ? colors.foreground.withValues(alpha: 0.02)
                : colors.foreground.withValues(alpha: 0.08),
            child: Container(
              constraints: const BoxConstraints(minHeight: _kMinButtonHeight),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.sm,
              ),
              alignment: Alignment.center,
              child: _buildContent(colors.foreground, motion),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foreground, AppMotion motion) {
    // Loading state contract:
    // - Loader REPLACES label (not overlay)
    // - Loader color follows button foreground
    // - Loader size is fixed (20x20) and not customizable
    // - Button height is preserved during loading via Container constraints
    return AnimatedSwitcher(
      duration: motion.fast,
      switchInCurve: motion.easeOut,
      switchOutCurve: motion.easeIn,
      child: loading
          ? SizedBox(
              key: const ValueKey('loader'),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(foreground),
              ),
            )
          : AppText(
              label,
              key: const ValueKey('label'),
              variant: AppTextVariant.label,
              color: _textColorFromForeground,
            ),
    );
  }

  /// Maps variant foreground to AppTextColor.
  /// Primary/destructive use inverse (on colored background).
  /// Secondary/ghost use primary (on neutral background).
  AppTextColor get _textColorFromForeground {
    return switch (variant) {
      AppButtonVariant.primary => AppTextColor.inverse,
      AppButtonVariant.secondary => AppTextColor.primary,
      AppButtonVariant.destructive => AppTextColor.inverse,
      AppButtonVariant.ghost => AppTextColor.primary,
    };
  }

  _ButtonColors _resolveMaterialColors(ColorScheme colorScheme) {
    // Colors derived from shell-injected theme.
    // This widget reads; it does not resolve tokens.
    return switch (variant) {
      AppButtonVariant.primary => _ButtonColors(
        background: colorScheme.primary,
        foreground: colorScheme.onPrimary,
      ),
      AppButtonVariant.secondary => _ButtonColors(
        background: colorScheme.surface,
        foreground: colorScheme.onSurface,
      ),
      AppButtonVariant.destructive => _ButtonColors(
        background: colorScheme.error,
        foreground: colorScheme.onError,
      ),
      AppButtonVariant.ghost => _ButtonColors(
        background: Colors.transparent,
        foreground: colorScheme.primary,
      ),
    };
  }
}

/// Cupertino implementation with opacity feedback.
class _CupertinoButton extends StatelessWidget {
  const _CupertinoButton({
    required this.label,
    required this.onPressed,
    required this.variant,
    required this.enabled,
    required this.loading,
    required this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool enabled;
  final bool loading;
  final String? semanticLabel;

  /// Contract: interaction enabled only if enabled == true && loading == false.
  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;
    final theme = CupertinoTheme.of(context);

    // Resolve colors from shell-injected theme based on variant.
    final colors = _resolveCupertinoColors(context, theme);

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: semanticLabel ?? label,
      child: AnimatedOpacity(
        // Contract: disabled visual treatment is opacity ONLY.
        opacity: _isInteractive ? 1.0 : 0.38,
        duration: motion.fast,
        curve: motion.easeOut,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size.fromHeight(_kMinButtonHeight),
          borderRadius: BorderRadius.circular(shape.md),
          color: colors.background,
          disabledColor: colors.background,
          onPressed: _isInteractive ? onPressed : null,
          child: Container(
            constraints: const BoxConstraints(minHeight: _kMinButtonHeight),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.sm,
            ),
            alignment: Alignment.center,
            child: _buildContent(colors.foreground, motion),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foreground, AppMotion motion) {
    // Loading state contract:
    // - Loader REPLACES label (not overlay)
    // - Loader color follows button foreground
    // - Loader size is fixed (20x20) and not customizable
    // - Button height is preserved during loading via Container constraints
    return AnimatedSwitcher(
      duration: motion.fast,
      switchInCurve: motion.easeOut,
      switchOutCurve: motion.easeIn,
      child: loading
          ? SizedBox(
              key: const ValueKey('loader'),
              width: 20,
              height: 20,
              child: CupertinoActivityIndicator(color: foreground),
            )
          : AppText(
              label,
              key: const ValueKey('label'),
              variant: AppTextVariant.label,
              color: _textColorFromForeground,
            ),
    );
  }

  /// Maps variant foreground to AppTextColor.
  AppTextColor get _textColorFromForeground {
    return switch (variant) {
      AppButtonVariant.primary => AppTextColor.inverse,
      AppButtonVariant.secondary => AppTextColor.primary,
      AppButtonVariant.destructive => AppTextColor.inverse,
      AppButtonVariant.ghost => AppTextColor.primary,
    };
  }

  _ButtonColors _resolveCupertinoColors(
    BuildContext context,
    CupertinoThemeData theme,
  ) {
    // Colors derived from shell-injected theme.
    // For Cupertino, we use the primaryColor and system colors.
    final primaryColor = theme.primaryColor;

    return switch (variant) {
      AppButtonVariant.primary => _ButtonColors(
        background: primaryColor,
        foreground: theme.primaryContrastingColor,
      ),
      AppButtonVariant.secondary => _ButtonColors(
        background: CupertinoColors.systemGrey5.resolveFrom(context),
        foreground: CupertinoColors.label.resolveFrom(context),
      ),
      AppButtonVariant.destructive => _ButtonColors(
        background: CupertinoColors.systemRed.resolveFrom(context),
        foreground: CupertinoColors.white,
      ),
      AppButtonVariant.ghost => _ButtonColors(
        background: CupertinoColors.transparent,
        foreground: primaryColor,
      ),
    };
  }
}

/// Internal color pair for button rendering.
class _ButtonColors {
  const _ButtonColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
