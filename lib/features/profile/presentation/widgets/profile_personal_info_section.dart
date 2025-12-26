import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

class ProfilePersonalInfoSection extends StatelessWidget {
  const ProfilePersonalInfoSection({
    super.key,
    required this.gender,
    required this.onGenderChanged,
    required this.birthYearLabel,
    required this.isBirthYearPlaceholder,
    required this.onBirthYearTap,
    required this.locationLabel,
    required this.isLocationPlaceholder,
    required this.onLocationTap,
  });

  final AppGender gender;
  final ValueChanged<AppGender> onGenderChanged;

  final String birthYearLabel;
  final bool isBirthYearPlaceholder;
  final VoidCallback onBirthYearTap;

  final String locationLabel;
  final bool isLocationPlaceholder;
  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppGenderSelector(value: gender, onChanged: onGenderChanged),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.systemBirthday,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Birth Year',
            value: birthYearLabel,
            isValuePlaceholder: isBirthYearPlaceholder,
            showsChevron: true,
            onTap: onBirthYearTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.systemLocation,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Location',
            value: locationLabel,
            isValuePlaceholder: isLocationPlaceholder,
            showsChevron: true,
            onTap: onLocationTap,
          ),
        ],
      ),
    );
  }
}
