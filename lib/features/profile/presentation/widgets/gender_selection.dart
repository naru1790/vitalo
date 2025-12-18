import 'package:flutter/cupertino.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/app_segmented_button.dart';

/// Gender selection using styled AppSegmentedButton
/// Matches the Unit System toggle for visual consistency
class GenderSelection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderSelected;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    // Normalize to valid key - handle case variations or invalid values
    final normalizedGender = switch (selectedGender?.toLowerCase()) {
      'female' => 'Female',
      _ => 'Male', // Default to Male for null or any other value
    };

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.person,
            size: AppSpacing.iconSizeSmall,
            color: primaryColor,
          ),
          const SizedBox(width: AppSpacing.md),
          Text('Gender', style: AppleTextStyles.callout(context)),
          const Spacer(),
          AppSegmentedButton<String>(
            children: const {'Male': Text('Male'), 'Female': Text('Female')},
            groupValue: normalizedGender,
            onValueChanged: (value) {
              onGenderSelected(value);
            },
          ),
        ],
      ),
    );
  }
}
