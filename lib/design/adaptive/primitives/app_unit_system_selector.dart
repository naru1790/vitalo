// @frozen
// Tier-1 semantic composite.
// Owns: mapping AppUnitSystem ↔ binary choice.
// Does NOT own layout or copy defaults.

import 'package:flutter/widgets.dart';

import '../widgets/app_labeled_binary_choice.dart';

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
    required this.label,
    required this.metricLabel,
    required this.imperialLabel,
  });

  final AppUnitSystem value;
  final ValueChanged<AppUnitSystem> onChanged;

  final Widget label;
  final String metricLabel;
  final String imperialLabel;

  @override
  Widget build(BuildContext context) {
    return AppLabeledBinaryChoice(
      label: label,
      leftLabel: metricLabel,
      rightLabel: imperialLabel,
      value: value == AppUnitSystem.imperial,
      onChanged: (isImperial) {
        onChanged(isImperial ? AppUnitSystem.imperial : AppUnitSystem.metric);
      },
    );
  }
}
