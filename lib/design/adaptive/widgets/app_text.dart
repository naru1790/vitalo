import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/typography.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic typography variants.
///
/// Each variant maps to a style in [AppTextStyles.of].
/// Feature code selects intent; tokens determine appearance.
enum AppTextVariant {
  /// Hero moments and celebratory messages.
  display,

  /// Screen and section headings.
  title,

  /// Primary reading text.
  body,

  /// Supporting and metadata text.
  caption,

  /// Interactive element text (buttons, tabs).
  label,
}

/// Semantic text color roles.
///
/// Each role maps to a semantic color in [AppColors].
/// Shells inject colors into platform themes; AppText reads them.
enum AppTextColor {
  /// Primary text for maximum contrast and readability.
  primary,

  /// Secondary text for supporting information.
  secondary,

  /// Disabled text for inactive states.
  disabled,

  /// Inverse text for use on dark/colored backgrounds.
  inverse,
}

/// Tier-0 adaptive text primitive.
///
/// The only legal way to render text in feature code.
/// Enforces semantic typography, semantic color roles, and predictable overflow.
///
/// Feature code MUST use this instead of [Text], [TextStyle], or theme text.
/// Typography comes from [AppTextStyles.of]; colors come from shell-injected
/// theme values.
///
/// Overflow behavior is frozen per variant and cannot be overridden.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    required this.variant,
    this.color = AppTextColor.primary,
    this.maxLines,
    this.align = TextAlign.start,
  });

  /// The text to display.
  final String text;

  /// Semantic typography variant.
  final AppTextVariant variant;

  /// Semantic color role.
  final AppTextColor color;

  /// Maximum number of lines. When null, uses variant default.
  final int? maxLines;

  /// Text alignment.
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final typography = AppTextStyles.of;

    // Select base style from static typography tokens.
    final TextStyle baseStyle = _resolveBaseStyle(typography);

    // Resolve color from shell-injected platform theme.
    final Color textColor = _resolveColor(context, platform);

    // Apply color to base style.
    final TextStyle style = baseStyle.copyWith(color: textColor);

    // Determine line limit (parameter overrides default).
    final int? effectiveMaxLines = maxLines ?? _defaultMaxLines;

    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: effectiveMaxLines,
      // Overflow behavior is frozen per variant — not overridable.
      overflow: _frozenOverflow,
    );
  }

  /// Maps variant to typography token.
  TextStyle _resolveBaseStyle(AppTypography typography) {
    return switch (variant) {
      AppTextVariant.display => typography.display,
      AppTextVariant.title => typography.title,
      AppTextVariant.body => typography.body,
      AppTextVariant.caption => typography.caption,
      AppTextVariant.label => typography.label,
    };
  }

  /// Resolves color from shell-injected platform theme.
  ///
  /// Shells inject semantic colors into platform themes:
  /// - AndroidShell → ColorScheme + TextTheme
  /// - IosShell → CupertinoThemeData
  ///
  /// This reads the result; it does not resolve tokens.
  Color _resolveColor(BuildContext context, AppPlatform platform) {
    if (platform == AppPlatform.ios) {
      return _resolveCupertinoColor(context);
    }
    return _resolveMaterialColor(context);
  }

  Color _resolveMaterialColor(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return switch (color) {
      AppTextColor.primary =>
        textTheme.bodyLarge?.color ?? colorScheme.onSurface,
      AppTextColor.secondary =>
        textTheme.bodyMedium?.color ??
            colorScheme.onSurface.withValues(alpha: 0.7),
      AppTextColor.disabled => theme.disabledColor,
      AppTextColor.inverse => colorScheme.onPrimary,
    };
  }

  Color _resolveCupertinoColor(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    // Shells inject semantic colors into CupertinoThemeData.
    // For colors not explicitly injected, use iOS semantic dynamic colors
    // which resolve against the current CupertinoTheme brightness.
    return switch (color) {
      AppTextColor.primary =>
        theme.textTheme.textStyle.color ??
            CupertinoColors.label.resolveFrom(context),
      AppTextColor.secondary => CupertinoColors.secondaryLabel.resolveFrom(
        context,
      ),
      AppTextColor.disabled => CupertinoColors.inactiveGray.resolveFrom(
        context,
      ),
      AppTextColor.inverse => theme.primaryContrastingColor,
    };
  }

  /// Default maxLines per variant.
  ///
  /// Frozen behavior — feature code may override maxLines but not this table.
  int? get _defaultMaxLines {
    return switch (variant) {
      AppTextVariant.display => 2,
      AppTextVariant.title => 1,
      AppTextVariant.body => null, // Unlimited
      AppTextVariant.caption => 2,
      AppTextVariant.label => 1,
    };
  }

  /// Frozen overflow behavior per variant.
  ///
  /// Cannot be overridden by feature code.
  TextOverflow get _frozenOverflow {
    return switch (variant) {
      AppTextVariant.display => TextOverflow.ellipsis,
      AppTextVariant.title => TextOverflow.ellipsis,
      AppTextVariant.body => TextOverflow.clip,
      AppTextVariant.caption => TextOverflow.ellipsis,
      AppTextVariant.label => TextOverflow.ellipsis,
    };
  }
}
