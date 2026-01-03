import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

/// Feature widget for the Profile → Body Measurements section content.
///
/// Mirrors the usage pattern of [ProfilePersonalInfoSection]: the parent page
/// owns the semantic section boundary (via [AppSection]) and passes semantic
/// labels + intent callbacks down.
///
/// This section is summary-only: it must not own any navigation/modal flows.
class ProfileBodyMeasurementsSection extends StatelessWidget {
  const ProfileBodyMeasurementsSection({
    super.key,
    required this.heightLabel,
    required this.weightLabel,
    required this.waistLabel,
    required this.onHeightTap,
    required this.onWeightTap,
    required this.onWaistTap,
  });

  final String heightLabel;
  final String weightLabel;
  final String waistLabel;

  final VoidCallback onHeightTap;
  final VoidCallback onWeightTap;
  final VoidCallback onWaistTap;

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
            isValuePlaceholder: weightLabel == '—',
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
            isValuePlaceholder: heightLabel == '—',
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
            isValuePlaceholder: waistLabel == '—',
            showsChevron: true,
            onTap: onWaistTap,
          ),
        ],
      ),
    );
  }
}
