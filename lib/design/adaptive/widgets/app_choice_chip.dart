// @frozen
// Tier-0 adaptive choice pill.
// Owns: platform-correct tap handling + selected visual state.
// Must NOT: store internal state, navigate, trigger haptics, branch on brightness.

import 'package:flutter/material.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import 'app_icon.dart';
import 'app_text.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onSelected;
  final icons.AppIcon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final colors = AppColorScope.of(context).colors;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;

    final background = selected
        ? colors.stateSelected.withValues(alpha: 0.14)
        : colors.neutralSurface;

    final borderColor = selected ? colors.stateSelected : colors.surfaceBorder;
    final borderWidth = selected ? shape.strokeVisible : shape.strokeSubtle;

    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(shape.full),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            AppIcon(
              leadingIcon!,
              size: AppIconSize.small,
              colorOverride: colors.textPrimary,
            ),
            SizedBox(width: spacing.xs),
          ],
          AppText(
            label,
            variant: AppTextVariant.label,
            color: AppTextColor.primary,
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      enabled: onSelected != null,
      label: label,
      child: switch (platform) {
        AppPlatform.ios => GestureDetector(onTap: onSelected, child: content),
        AppPlatform.android => Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shape.full),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onSelected,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(shape.full),
            ),
            child: content,
          ),
        ),
      },
    );
  }
}
