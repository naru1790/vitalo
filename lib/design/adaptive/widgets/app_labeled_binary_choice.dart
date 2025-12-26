// @frozen
// Tier-0 / Tier-1 true primitive.
// Owns: structure + interaction.
// Does NOT own: domain meaning, copy defaults, or platform logic.

import 'package:flutter/widgets.dart';

import 'app_binary_segmented_control.dart';
import 'app_control_surface.dart';
import 'app_labeled_row.dart';

/// Labeled binary choice primitive.
///
/// Invariants:
/// - Expects exactly two mutually exclusive options.
/// - Not suitable for tri-state, nullable, or multi-select selections.
/// - Does not own domain meaning or copy; callers must provide semantics.
class AppLabeledBinaryChoice extends StatelessWidget {
  const AppLabeledBinaryChoice({
    super.key,
    required this.label,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.onChanged,
  });

  final Widget label;
  final String leftLabel;
  final String rightLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppLabeledRow(
      label: label,
      trailing: AppControlSurface(
        child: AppBinarySegmentedControl(
          leftLabel: leftLabel,
          rightLabel: rightLabel,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
