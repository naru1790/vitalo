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
  });

  final AppGender gender;
  final ValueChanged<AppGender> onGenderChanged;

  final String birthYearLabel;
  final bool isBirthYearPlaceholder;
  final VoidCallback onBirthYearTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppGenderSelector(
            value: gender,
            onChanged: onGenderChanged,
            label: Row(
              children: [
                const AppIcon(
                  icons.AppIcon.navProfile,
                  size: AppIconSize.small,
                  color: AppIconColor.brand,
                ),
                SizedBox(width: Spacing.of.md),
                const AppText(
                  'Gender',
                  variant: AppTextVariant.body,
                  color: AppTextColor.primary,
                ),
              ],
            ),
            maleLabel: 'Male',
            femaleLabel: 'Female',
          ),

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
        ],
      ),
    );
  }
}
