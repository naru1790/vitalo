import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

class ProfilePreferencesSection extends StatelessWidget {
  const ProfilePreferencesSection({
    super.key,
    required this.unitSystem,
    required this.onUnitSystemChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  final AppUnitSystem unitSystem;
  final ValueChanged<AppUnitSystem> onUnitSystemChanged;

  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          // Measurement unit system is a global user preference.
          // Body & Health consumes this value but does not own it.
          AppUnitSystemSelector(
            value: unitSystem,
            onChanged: onUnitSystemChanged,
            label: Row(
              children: [
                const AppIcon(
                  icons.AppIcon.systemUnits,
                  size: AppIconSize.small,
                  color: AppIconColor.brand,
                ),
                SizedBox(width: Spacing.of.md),
                const AppText(
                  'Unit System',
                  variant: AppTextVariant.body,
                  color: AppTextColor.primary,
                ),
              ],
            ),
            metricLabel: 'Metric',
            imperialLabel: 'Imperial',
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.systemNotificationSettings,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Notifications',
            trailing: AppToggle(
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
          ),
        ],
      ),
    );
  }
}
