import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Reusable menu tile for profile settings
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.onTap,
    this.showArrow = true,
    this.titleColor,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              decoration: BoxDecoration(
                color:
                    (iconColor ??
                            (isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary))
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  AppSpacing.cardRadiusSmall - 2,
                ),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconSizeSmall,
                color:
                    iconColor ??
                    (isDark ? AppColors.darkPrimary : AppColors.primary),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color:
                          titleColor ??
                          (isDark
                              ? AppColors.darkOnSurface
                              : AppColors.onSurface),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            subtitleColor ??
                            (isDark
                                ? AppColors.darkOnSurfaceVariant
                                : AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showArrow && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                size: AppSpacing.iconSize - 2,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
