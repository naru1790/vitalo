// @frozen
// Tier-1 composite primitive.
// Owns: semantic gender selection layout.
// Uses: AppListTile (label) + AppBinarySegmentedControl (selection).
// Must NOT: access platform APIs or raw widgets.

import 'package:flutter/widgets.dart';

import '../widgets/app_list_tile.dart';
import '../widgets/app_binary_segmented_control.dart';
import '../widgets/app_icon.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';

/// Semantic gender representation.
///
/// Binary selection with no string-based domain leakage.
enum AppGender { male, female }

/// Tier-1 gender selector primitive.
///
/// Composes label row and selection control via Column layout.
/// - AppListTile says "what" (icon + label)
/// - AppBinarySegmentedControl says "how" (toggle selection)
/// - AppGenderSelector decides "where" (vertical composition)
///
/// Feature code uses this instead of building gender rows manually.
class AppGenderSelector extends StatelessWidget {
  const AppGenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Currently selected gender.
  final AppGender value;

  /// Called when gender changes.
  final ValueChanged<AppGender> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label row (what)
        const AppListTile(
          leading: AppIcon(
            icons.AppIcon.navProfile,
            size: AppIconSize.small,
            color: AppIconColor.primary,
          ),
          title: 'Gender',
        ),
        SizedBox(height: spacing.sm),
        // Selection control (how)
        AppBinarySegmentedControl(
          leftLabel: 'Male',
          rightLabel: 'Female',
          value: value == AppGender.female,
          onChanged: (isFemale) {
            onChanged(isFemale ? AppGender.female : AppGender.male);
          },
        ),
      ],
    );
  }
}
