// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic icon sizes.
///
/// Feature code selects intent; values are resolved internally.
/// Raw doubles are never exposed.
enum AppIconSize {
  /// Inline size for low-priority affordances (12px).
  ///
  /// Use for inline links, legal footers, and contexts where
  /// the icon must be visually secondary to accompanying text.
  xs,

  /// Compact size for dense layouts (16px).
  small,

  /// Standard size for most contexts (24px).
  medium,

  /// Prominent size for emphasis (32px).
  large,
}

/// Semantic icon color roles.
///
/// Each role maps to semantic colors in [AppColors].
/// AppIcon reads colors directly from [AppColorScope].
enum AppIconColor {
  /// Primary icon color for maximum contrast.
  primary,

  /// Secondary icon color for supporting elements.
  secondary,

  /// Disabled icon color for inactive states.
  disabled,

  /// Inverse icon color for dark/colored backgrounds.
  inverse,

  /// Brand icon color for accent/branded elements.
  brand,
}

/// Tier-0 adaptive icon primitive.
///
/// The only legal way to render icons in feature code.
/// Enforces semantic icon identity, semantic sizing, and semantic color roles.
///
/// Feature code MUST use this instead of [Icon], [Icons], or [CupertinoIcons].
/// Icon glyphs come from [icons.AppIcons.resolve]; colors come from
/// [AppColorScope.colors].
///
/// ## Responsibility Boundaries
///
/// This widget is **visual-only**:
/// - Renders icon glyph with semantic size and color
/// - Passes accessibility label to underlying widget
///
/// This widget does **NOT** handle:
/// - Hit targets or touch areas
/// - Tap/press gestures
/// - Padding or layout spacing
/// - Animation or transitions
///
/// For interactive icons, use [AppIconButton].
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color = AppIconColor.primary,
    this.colorOverride,
    this.semanticLabel,
  });

  /// Semantic icon identifier.
  final icons.AppIcon icon;

  /// Semantic size.
  final AppIconSize size;

  /// Semantic color role.
  ///
  /// Used when [colorOverride] is null.
  final AppIconColor color;

  /// Explicit semantic color override.
  ///
  /// When provided, bypasses [color] role resolution.
  /// Use ONLY with colors from [AppColors] (e.g., `colors.brandPrimary`).
  /// Raw color values are forbidden.
  ///
  /// This exists for contexts where the icon must match a specific
  /// semantic color that is not part of the standard role set
  /// (e.g., brandPrimary for legal links).
  final Color? colorOverride;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;

    // Resolve glyph from semantic icon via static resolver.
    final IconData iconData = icons.AppIcons.resolve(icon);

    // Resolve size from semantic enum.
    final double iconSize = _resolveSize();

    // Resolve color: override takes precedence, otherwise use role.
    final Color iconColor = colorOverride ?? _resolveColor(colors);

    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
      semanticLabel: semanticLabel,
    );
  }

  /// Maps semantic size to pixel value.
  ///
  /// These values are frozen. Feature code cannot override.
  double _resolveSize() {
    return switch (size) {
      AppIconSize.xs => 12.0,
      AppIconSize.small => 16.0,
      AppIconSize.medium => 24.0,
      AppIconSize.large => 32.0,
    };
  }

  /// Resolves color from environment scope.
  ///
  /// Colors are resolved once by AdaptiveShell and carried via
  /// AppColorScope. This reads directly from that scope.
  Color _resolveColor(AppColors colors) {
    return switch (color) {
      AppIconColor.primary => colors.textPrimary,
      AppIconColor.secondary => colors.textSecondary,
      AppIconColor.disabled => colors.textTertiary,
      AppIconColor.inverse => colors.textInverse,
      AppIconColor.brand => colors.brandPrimary,
    };
  }
}
