import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

/// Feature widget for the Profile → Integrations section content.
///
/// Summary-only: owns no navigation, modals, or permission popups.
class ProfileIntegrationsSection extends StatelessWidget {
  const ProfileIntegrationsSection({
    super.key,
    required this.healthConnected,
    required this.onHealthChanged,
  });

  final bool healthConnected;
  final ValueChanged<bool> onHealthChanged;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.actionSync,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Health Sync',
            trailing: AppToggle(
              value: healthConnected,
              onChanged: onHealthChanged,
            ),
          ),
        ],
      ),
    );
  }
}
