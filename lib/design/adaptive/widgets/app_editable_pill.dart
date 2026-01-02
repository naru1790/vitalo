// @frozen
// Tier-0 editable pill.
// Owns: remove affordance + platform-correct tap feedback.
// Must NOT: store internal state, navigate, branch on brightness.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import 'app_icon.dart';
import 'app_text.dart';

class AppEditablePill extends StatelessWidget {
  const AppEditablePill({
    super.key,
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final colors = AppColorScope.of(context).colors;
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;

    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.neutralSurface,
        borderRadius: BorderRadius.circular(shape.full),
        border: Border.all(
          color: colors.surfaceBorder,
          width: shape.strokeSubtle,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppText(
              label,
              variant: AppTextVariant.label,
              color: AppTextColor.primary,
              maxLines: 1,
            ),
          ),
          SizedBox(width: spacing.xs),
          AppIcon(
            icons.AppIcon.actionClose,
            size: AppIconSize.small,
            colorOverride: colors.textSecondary,
          ),
        ],
      ),
    );

    return Semantics(
      button: false,
      label: 'Remove $label',
      onTapHint: 'Removes item',
      child: switch (platform) {
        AppPlatform.ios => GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onRemove();
          },
          child: content,
        ),
        AppPlatform.android => Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shape.full),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onRemove,
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
