import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

/// Feature widget for the Profile → Body & Health section content.
///
/// Mirrors the usage pattern of [ProfilePersonalInfoSection]: the parent page owns
/// the semantic section boundary (via [AppSection]) and passes semantic labels
/// + intent callbacks down.
///
/// This section is summary-only: it must not own any navigation/modal flows.
class ProfileBodyHealthSection extends StatelessWidget {
  const ProfileBodyHealthSection({
    super.key,
    required this.heightLabel,
    required this.weightLabel,
    required this.waistLabel,
    required this.healthConditionsValue,
    required this.healthConditionsSubtitle,
    required this.onHeightTap,
    required this.onWeightTap,
    required this.onWaistTap,
    required this.onHealthConditionsTap,
  });

  final String heightLabel;
  final String weightLabel;
  final String waistLabel;

  /// When the user has no conditions, this should usually be "I'm healthy".
  /// When the user has conditions, this should typically be null and the
  /// summary should be provided via [healthConditionsSubtitle].
  final String? healthConditionsValue;

  /// Summary of conditions, shown only when the user has selected issues.
  final String? healthConditionsSubtitle;

  final VoidCallback onHeightTap;
  final VoidCallback onWeightTap;
  final VoidCallback onWaistTap;
  final VoidCallback onHealthConditionsTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthWeight,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Weight',
            value: weightLabel,
            showsChevron: true,
            onTap: onWeightTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthHeight,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Height',
            value: heightLabel,
            showsChevron: true,
            onTap: onHeightTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthWaist,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Waist',
            value: waistLabel,
            showsChevron: true,
            onTap: onWaistTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthConditions,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Health Conditions',
            value: healthConditionsValue,
            subtitle: healthConditionsSubtitle,
            showsChevron: true,
            onTap: onHealthConditionsTap,
          ),
        ],
      ),
    );
  }
}
