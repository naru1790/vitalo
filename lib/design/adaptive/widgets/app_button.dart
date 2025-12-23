// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_environment_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/motion.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import 'app_icon.dart';
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
/// The only legal way to render action buttons in feature code.
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
/// - Optional leading icon (rendered via AppIcon)
/// - Platform-appropriate feedback (ripple on Android, opacity on iOS)
/// - Disabled and loading state management
/// - Minimum touch target sizing
///
/// This widget does **NOT** handle:
/// - Custom sizes or padding
/// - Hover or focus states
/// - Icon-only buttons (use [AppIconButton])
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
    this.leadingIcon,
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

  /// Optional leading semantic icon.
  ///
  /// When provided, renders before the label with standard spacing.
  /// AppButton owns icon size, spacing, and color — feature code only
  /// provides the semantic icon identifier.
  final icons.AppIcon? leadingIcon;

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
        leadingIcon: leadingIcon,
        semanticLabel: semanticLabel,
      );
    }

    return _MaterialButton(
      label: label,
      onPressed: onPressed,
      variant: variant,
      enabled: enabled,
      loading: loading,
      leadingIcon: leadingIcon,
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

/// Single semantic color resolver for all button variants.
///
/// This is the ONLY place where variant → color mapping is defined.
/// Both platform implementations consume these resolved colors.
/// Platform widgets are dumb renderers — they do NOT define meaning.
_ButtonColors _resolveButtonColors(AppButtonVariant variant, AppColors colors) {
  return switch (variant) {
    AppButtonVariant.primary => _ButtonColors(
      background: colors.brandPrimary,
      foreground: colors.textInverse,
      textColor: AppTextColor.inverse,
    ),
    AppButtonVariant.secondary => _ButtonColors(
      background: colors.neutralSurface,
      foreground: colors.textPrimary,
      textColor: AppTextColor.primary,
    ),
    AppButtonVariant.destructive => _ButtonColors(
      background: colors.feedbackError,
      foreground: colors.textInverse,
      textColor: AppTextColor.inverse,
    ),
    AppButtonVariant.ghost => _ButtonColors(
      background: Colors.transparent,
      foreground: colors.brandPrimary,
      textColor: AppTextColor.primary,
    ),
  };
}

/// Material implementation with ink ripple feedback.
class _MaterialButton extends StatelessWidget {
  const _MaterialButton({
    required this.label,
    required this.onPressed,
    required this.variant,
    required this.enabled,
    required this.loading,
    required this.leadingIcon,
    required this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool enabled;
  final bool loading;
  final icons.AppIcon? leadingIcon;
  final String? semanticLabel;

  /// Contract: interaction enabled only if enabled == true && loading == false.
  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;

    final appColors = AppColorScope.of(context).colors;
    final colors = _resolveButtonColors(variant, appColors);

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
              child: _buildContent(colors, motion, spacing),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    _ButtonColors colors,
    AppMotion motion,
    AppSpacing spacing,
  ) {
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
                valueColor: AlwaysStoppedAnimation(colors.foreground),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  AppIcon(
                    leadingIcon!,
                    size: AppIconSize.small,
                    colorOverride: colors.foreground,
                  ),
                  SizedBox(width: spacing.sm),
                ],
                AppText(
                  label,
                  variant: AppTextVariant.label,
                  color: colors.textColor,
                ),
              ],
            ),
    );
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
    required this.leadingIcon,
    required this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool enabled;
  final bool loading;
  final icons.AppIcon? leadingIcon;
  final String? semanticLabel;

  /// Contract: interaction enabled only if enabled == true && loading == false.
  bool get _isInteractive => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;

    final appColors = AppColorScope.of(context).colors;
    final colors = _resolveButtonColors(variant, appColors);

    return Semantics(
      button: true,
      enabled: _isInteractive,
      label: semanticLabel ?? label,
      child: Opacity(
        // Contract: disabled visual treatment is opacity ONLY.
        // Static opacity — CupertinoButton handles press feedback natively.
        opacity: _isInteractive ? 1.0 : 0.38,
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
            child: _buildContent(colors, motion, spacing),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    _ButtonColors colors,
    AppMotion motion,
    AppSpacing spacing,
  ) {
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
              child: CupertinoActivityIndicator(color: colors.foreground),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  AppIcon(
                    leadingIcon!,
                    size: AppIconSize.small,
                    colorOverride: colors.foreground,
                  ),
                  SizedBox(width: spacing.sm),
                ],
                AppText(
                  label,
                  variant: AppTextVariant.label,
                  color: colors.textColor,
                ),
              ],
            ),
    );
  }
}

/// Internal color tuple for button rendering.
class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.textColor,
  });

  final Color background;
  final Color foreground;
  final AppTextColor textColor;
}
