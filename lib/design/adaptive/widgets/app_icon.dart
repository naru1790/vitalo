import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic icon sizes.
///
/// Feature code selects intent; values are resolved internally.
/// Raw doubles are never exposed.
enum AppIconSize {
  /// Compact size for dense layouts (16px).
  small,

  /// Standard size for most contexts (24px).
  medium,

  /// Prominent size for emphasis (32px).
  large,
}

/// Semantic icon color roles.
///
/// Each role maps to shell-injected theme colors.
/// AppIcon reads these; it does not resolve tokens.
enum AppIconColor {
  /// Primary icon color for maximum contrast.
  primary,

  /// Secondary icon color for supporting elements.
  secondary,

  /// Disabled icon color for inactive states.
  disabled,

  /// Inverse icon color for dark/colored backgrounds.
  inverse,
}

/// Tier-0 adaptive icon primitive.
///
/// The only legal way to render icons in feature code.
/// Enforces semantic icon identity, semantic sizing, and semantic color roles.
///
/// Feature code MUST use this instead of [Icon], [Icons], or [CupertinoIcons].
/// Icon glyphs come from [icons.AppIcons.resolve]; colors come from shell-injected
/// theme values.
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
    this.semanticLabel,
  });

  /// Semantic icon identifier.
  final icons.AppIcon icon;

  /// Semantic size.
  final AppIconSize size;

  /// Semantic color role.
  final AppIconColor color;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    // Resolve glyph from semantic icon via static resolver.
    final IconData iconData = icons.AppIcons.resolve(icon);

    // Resolve size from semantic enum.
    final double iconSize = _resolveSize();

    // Resolve color from shell-injected platform theme.
    final Color iconColor = _resolveColor(context, platform);

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
      AppIconSize.small => 16.0,
      AppIconSize.medium => 24.0,
      AppIconSize.large => 32.0,
    };
  }

  /// Resolves color from shell-injected platform theme.
  Color _resolveColor(BuildContext context, AppPlatform platform) {
    if (platform == AppPlatform.ios) {
      return _resolveCupertinoColor(context);
    }
    return _resolveMaterialColor(context);
  }

  Color _resolveMaterialColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return switch (color) {
      AppIconColor.primary => colorScheme.onSurface,
      AppIconColor.secondary => colorScheme.onSurface.withOpacity(0.7),
      AppIconColor.disabled => theme.disabledColor,
      AppIconColor.inverse => colorScheme.onPrimary,
    };
  }

  Color _resolveCupertinoColor(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    // Exception: CupertinoColors.* used directly here.
    //
    // Unlike Material's ColorScheme, CupertinoThemeData does not expose
    // semantic text/icon color roles (secondary, disabled, etc.).
    // CupertinoColors.label/secondaryLabel/inactiveGray are iOS system
    // dynamic colors that resolve correctly against the current brightness.
    // This is the idiomatic iOS approach and is acceptable here.
    return switch (color) {
      AppIconColor.primary => CupertinoColors.label.resolveFrom(context),
      AppIconColor.secondary => CupertinoColors.secondaryLabel.resolveFrom(
        context,
      ),
      AppIconColor.disabled => CupertinoColors.inactiveGray.resolveFrom(
        context,
      ),
      AppIconColor.inverse => theme.primaryContrastingColor,
    };
  }
}
