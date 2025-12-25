// @frozen
// Tier-1 composite primitive.
// Owns: semantic gender selection layout.
// Uses: AppLabeledRow (label) + AppBinarySegmentedControl (selection).
// Must NOT: access platform APIs or raw widgets.

import 'package:flutter/widgets.dart';

import '../widgets/app_binary_segmented_control.dart';
import '../widgets/app_control_surface.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_labeled_row.dart';
import '../widgets/app_text.dart';
import '../../tokens/icons.dart' as icons;

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
    this.label = 'Gender',
    this.maleLabel = 'Male',
    this.femaleLabel = 'Female',
  });

  /// Currently selected gender.
  final AppGender value;

  /// Called when gender changes.
  final ValueChanged<AppGender> onChanged;

  /// Label text (for localization override).
  final String label;

  /// Male option label (for localization override).
  final String maleLabel;

  /// Female option label (for localization override).
  final String femaleLabel;

  @override
  Widget build(BuildContext context) {
    return AppLabeledRow(
      leading: const AppIcon(
        // Using navProfile (person silhouette) as gender-neutral icon.
        // Semantically represents "personal identity" in profile context.
        icons.AppIcon.navProfile,
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
          leftLabel: maleLabel,
          rightLabel: femaleLabel,
          value: value == AppGender.female,
          onChanged: (isFemale) {
            onChanged(isFemale ? AppGender.female : AppGender.male);
          },
        ),
      ),
    );
  }
}
