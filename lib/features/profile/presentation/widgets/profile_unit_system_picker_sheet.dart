import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;
import 'profile_body_health_section.dart' show UnitSystem;

class ProfileUnitSystemPickerSheet extends StatelessWidget {
  const ProfileUnitSystemPickerSheet({super.key, required this.value});

  final UnitSystem value;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppListTile(
            title: 'Metric',
            value: 'kg, cm',
            trailing: value == UnitSystem.metric
                ? const AppIcon(
                    icons.AppIcon.actionConfirm,
                    size: AppIconSize.small,
                    color: AppIconColor.brand,
                  )
                : null,
            onTap: () => Navigator.pop(context, UnitSystem.metric),
          ),

          const AppDivider(inset: AppDividerInset.none),

          AppListTile(
            title: 'Imperial',
            value: 'lbs, ft/in',
            trailing: value == UnitSystem.imperial
                ? const AppIcon(
                    icons.AppIcon.actionConfirm,
                    size: AppIconSize.small,
                    color: AppIconColor.brand,
                  )
                : null,
            onTap: () => Navigator.pop(context, UnitSystem.imperial),
          ),
        ],
      ),
    );
  }
}
