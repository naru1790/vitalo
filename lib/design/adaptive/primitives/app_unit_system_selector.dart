// @frozen
// Tier-1 composite primitive.
// Owns: semantic unit-system selection layout.
// Uses: AppLabeledRow (label) + AppBinarySegmentedControl (selection).
// Must NOT: access platform APIs or raw widgets.

import 'package:flutter/widgets.dart';

import '../widgets/app_binary_segmented_control.dart';
import '../widgets/app_control_surface.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_labeled_row.dart';
import '../widgets/app_text.dart';
import '../../tokens/icons.dart' as icons;

/// Semantic unit system representation.
///
/// Binary selection for measurement display.
enum AppUnitSystem { metric, imperial }

/// Tier-1 unit system selector primitive.
///
/// Composes label and segmented control via horizontal layout.
/// - AppLabeledRow provides structure
/// - AppBinarySegmentedControl provides selection UI
class AppUnitSystemSelector extends StatelessWidget {
  const AppUnitSystemSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Unit System',
    this.metricLabel = 'Metric',
    this.imperialLabel = 'Imperial',
  });

  final AppUnitSystem value;
  final ValueChanged<AppUnitSystem> onChanged;

  final String label;
  final String metricLabel;
  final String imperialLabel;

  @override
  Widget build(BuildContext context) {
    return AppLabeledRow(
      leading: const AppIcon(
        icons.AppIcon.systemUnits,
        size: AppIconSize.small,
        color: AppIconColor.brand,
      ),
      label: AppText(
        label,
        variant: AppTextVariant.body,
        color: AppTextColor.primary,
      ),
      trailing: AppControlSurface(
        child: AppBinarySegmentedControl(
          leftLabel: metricLabel,
          rightLabel: imperialLabel,
          value: value == AppUnitSystem.imperial,
          onChanged: (isImperial) {
            onChanged(
              isImperial ? AppUnitSystem.imperial : AppUnitSystem.metric,
            );
          },
        ),
      ),
    );
  }
}
