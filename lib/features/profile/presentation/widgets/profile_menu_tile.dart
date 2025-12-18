import 'package:flutter/cupertino.dart';

import '../../../../core/theme.dart';

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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
                color: (iconColor ?? primaryColor).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconSizeSmall,
                color: iconColor ?? primaryColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppleTextStyles.subhead(context).copyWith(
                      color: titleColor ?? labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: AppleTextStyles.footnote(
                        context,
                      ).copyWith(color: subtitleColor ?? secondaryLabel),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showArrow && trailing == null)
              Icon(
                CupertinoIcons.chevron_right,
                size: AppSpacing.iconSize,
                color: secondaryLabel,
              ),
          ],
        ),
      ),
    );
  }
}
