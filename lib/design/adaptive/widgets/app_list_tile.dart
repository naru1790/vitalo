// @frozen
// Tier-1 adaptive list tile primitive.
// Owns: typography, spacing, dividers, platform-correct interaction.
// Must NOT: accept raw widgets, allow custom styling knobs.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/motion.dart';
import '../../tokens/spacing.dart';
import 'app_text.dart';
import 'app_icon.dart';
import 'app_icon_button.dart';
import 'app_divider.dart';

enum AppListTileDivider { none, full, inset }

/// Tier-1 adaptive list tile primitive.
///
/// The only legal way to render list rows in feature code.
/// Enforces typography, spacing, dividers, and platform-correct interaction.
///
/// Feature code MUST use this instead of:
/// - [ListTile]
/// - [CupertinoListTile]
/// - [InkWell]/[GestureDetector]
/// - Raw padding/Text/Icon widgets
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.divider = AppListTileDivider.none,
    this.enabled = true,
  }) : assert(
         leading == null || leading is AppIcon || leading is AppIconButton,
         'leading must be AppIcon or AppIconButton',
       ),
       assert(
         trailing == null || trailing is AppIcon || trailing is AppIconButton,
         'trailing must be AppIcon or AppIconButton',
       );

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppListTileDivider divider;
  final bool enabled;

  bool get _isInteractive => onTap != null && enabled;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final spacing = Spacing.of;
    final motion = AppMotionTokens.of;

    final row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            ExcludeSemantics(child: leading!),
            SizedBox(width: spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(title, variant: AppTextVariant.body),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xs),
                  AppText(subtitle!, variant: AppTextVariant.caption),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: spacing.md),
            ExcludeSemantics(child: trailing!),
          ],
        ],
      ),
    );

    final interactiveChild = _buildPlatformContainer(
      platform: platform,
      motion: motion,
      child: row,
    );

    final tile = Column(
      mainAxisSize: MainAxisSize.min,
      children: [interactiveChild, _buildDivider()],
    );

    return Semantics(
      container: true,
      button: _isInteractive,
      enabled: enabled,
      child: MergeSemantics(child: tile),
    );
  }

  Widget _buildPlatformContainer({
    required AppPlatform platform,
    required AppMotion motion,
    required Widget child,
  }) {
    // Opacity reduced when disabled; no color mutations.
    final opacity = enabled ? 1.0 : 0.38;

    if (!_isInteractive) {
      return AnimatedOpacity(
        opacity: opacity,
        duration: motion.fast,
        curve: motion.easeOut,
        child: child,
      );
    }

    if (platform == AppPlatform.ios) {
      return _CupertinoTappable(
        opacity: opacity,
        motion: motion,
        onTap: onTap!,
        child: child,
      );
    }

    return _MaterialTappable(
      opacity: opacity,
      motion: motion,
      onTap: onTap!,
      child: child,
    );
  }

  Widget _buildDivider() {
    return switch (divider) {
      AppListTileDivider.none => const SizedBox.shrink(),
      AppListTileDivider.full => const AppDivider(inset: AppDividerInset.none),
      AppListTileDivider.inset => const AppDivider(
        inset: AppDividerInset.leading,
      ),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE — INTERACTION WRAPPERS
// ═══════════════════════════════════════════════════════════════════════════

class _MaterialTappable extends StatelessWidget {
  const _MaterialTappable({
    required this.opacity,
    required this.motion,
    required this.onTap,
    required this.child,
  });

  final double opacity;
  final AppMotion motion;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: motion.fast,
          curve: motion.easeOut,
          child: child,
        ),
      ),
    );
  }
}

class _CupertinoTappable extends StatelessWidget {
  const _CupertinoTappable({
    required this.opacity,
    required this.motion,
    required this.onTap,
    required this.child,
  });

  final double opacity;
  final AppMotion motion;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // ignore: deprecated_member_use
      minSize: 0,
      onPressed: onTap,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: motion.fast,
        curve: motion.easeOut,
        child: child,
      ),
    );
  }
}
