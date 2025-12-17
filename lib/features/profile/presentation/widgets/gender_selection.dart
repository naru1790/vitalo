import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

/// Gender selection using styled SegmentedButton
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: AppSpacing.iconSizeSmall,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Gender',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          const Spacer(),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'Male', label: Text('Male')),
              ButtonSegment(value: 'Female', label: Text('Female')),
              ButtonSegment(value: 'Others', label: Text('Others')),
            ],
            selected: selectedGender != null ? {selectedGender!} : {},
            emptySelectionAllowed: true,
            onSelectionChanged: (selection) {
              onGenderSelected(selection.isEmpty ? null : selection.first);
            },
          ),
        ],
      ),
    );
  }
}
