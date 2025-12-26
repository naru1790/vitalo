// @frozen
// Tier-1 semantic composite.
// Owns: mapping AppGender ↔ binary choice.
// Does NOT own layout or copy defaults.

import 'package:flutter/widgets.dart';

import '../widgets/app_labeled_binary_choice.dart';
import '../widgets/app_text.dart';

/// Semantic gender representation.
///
/// Binary selection with no string-based domain leakage.
enum AppGender { male, female }

/// Tier-1 gender selector primitive.
///
/// Composes label and segmented control via horizontal layout.
/// - AppLabeledRow provides icon + label structure
/// - AppBinarySegmentedControl provides selection UI
///
/// NOTE:
/// This control intentionally models a binary gender choice.
/// Expanding beyond male/female requires a new primitive,
/// not modification of this one.
///
/// Feature code uses this instead of building gender rows manually.
class AppGenderSelector extends StatelessWidget {
  const AppGenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.maleLabel,
    required this.femaleLabel,
  });

  /// Currently selected gender.
  final AppGender value;

  /// Called when gender changes.
  final ValueChanged<AppGender> onChanged;

  /// Label widget owned by feature code.
  final Widget label;

  /// Male option label (for localization override).
  final String maleLabel;

  /// Female option label (for localization override).
  final String femaleLabel;

  @override
  Widget build(BuildContext context) {
    return AppLabeledBinaryChoice(
      label: label,
      leftLabel: maleLabel,
      rightLabel: femaleLabel,
      value: value == AppGender.female,
      onChanged: (isFemale) {
        onChanged(isFemale ? AppGender.female : AppGender.male);
      },
    );
  }
}
