import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

/// Feature widget for the Profile → Account section content.
///
/// Summary-only: owns no navigation or modal flows.
class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({
    super.key,
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
    required this.onSignOutTap,
  });

  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;
  final VoidCallback onSignOutTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;

    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.systemPrivacy,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Privacy Policy',
            showsChevron: true,
            onTap: onPrivacyPolicyTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.feedbackInfo,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Terms of Service',
            showsChevron: true,
            onTap: onTermsTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: AppIcon(
              icons.AppIcon.accountSignOut,
              size: AppIconSize.small,
              colorOverride: colors.actionDestructive,
            ),
            title: 'Sign Out',
            onTap: onSignOutTap,
          ),
        ],
      ),
    );
  }
}
