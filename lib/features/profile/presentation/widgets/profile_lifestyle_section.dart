import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Feature widget for the Profile → Lifestyle section content.
///
/// Summary-only: must not own any navigation/modal flows.
class ProfileLifestyleSection extends StatelessWidget {
  const ProfileLifestyleSection({
    super.key,
    required this.activityLabel,
    required this.isActivityPlaceholder,
    required this.onActivityTap,
    required this.sleepLabel,
    required this.isSleepPlaceholder,
    required this.onSleepTap,
    required this.dietLabel,
    required this.isDietPlaceholder,
    required this.onDietTap,
  });

  final String activityLabel;
  final bool isActivityPlaceholder;
  final VoidCallback onActivityTap;

  final String sleepLabel;
  final bool isSleepPlaceholder;
  final VoidCallback onSleepTap;

  final String dietLabel;
  final bool isDietPlaceholder;
  final VoidCallback onDietTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppListTile(
            title: 'Activity',
            value: activityLabel,
            isValuePlaceholder: isActivityPlaceholder,
            showsChevron: true,
            onTap: onActivityTap,
          ),
          const AppDivider(inset: AppDividerInset.content),
          AppListTile(
            title: 'Sleep',
            value: sleepLabel,
            isValuePlaceholder: isSleepPlaceholder,
            showsChevron: true,
            onTap: onSleepTap,
          ),
          const AppDivider(inset: AppDividerInset.content),
          AppListTile(
            title: 'Diet',
            value: dietLabel,
            isValuePlaceholder: isDietPlaceholder,
            showsChevron: true,
            onTap: onDietTap,
          ),
        ],
      ),
    );
  }
}
