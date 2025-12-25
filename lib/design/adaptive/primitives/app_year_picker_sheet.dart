// @frozen
// Feature sheet content.
// Owns: header, confirm action, navigation, current time reading.
// Uses: AppYearPicker (domain logic).
// Must NOT: duplicate domain logic owned by AppYearPicker.

import 'package:flutter/widgets.dart';

import 'app_year_picker.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../../tokens/spacing.dart';

/// Feature-level year picker sheet content.
///
/// Reusable sheet content for birth year selection.
/// Not a primitive — owns feature concerns (navigation, time).
/// Use with SheetPage when presenting via AppBottomSheet:
///
/// ```dart
/// final year = await AppBottomSheet.show<int>(
///   context,
///   sheet: SheetPage(
///     child: AppYearPickerSheet(initialYear: _birthYear),
///   ),
/// );
/// ```
class AppYearPickerSheet extends StatefulWidget {
  const AppYearPickerSheet({
    super.key,
    this.initialYear,
    this.minYear = 1920,
    this.title = 'Birth Year',
    this.subtitle = 'For age-based health insights',
  });

  final int? initialYear;
  final int minYear;
  final String title;
  final String? subtitle;

  @override
  State<AppYearPickerSheet> createState() => _AppYearPickerSheetState();
}

class _AppYearPickerSheetState extends State<AppYearPickerSheet> {
  int? _selectedYear;

  void _handleDone() {
    if (_selectedYear != null) {
      Navigator.pop(context, _selectedYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with title, subtitle, and Done button
        _SheetHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          onDone: _handleDone,
        ),

        SizedBox(height: spacing.md),

        // Year picker — owns all domain logic
        AppYearPicker(
          currentYear: DateTime.now().year,
          initialYear: widget.initialYear,
          minYear: widget.minYear,
          onYearChanged: (year) {
            _selectedYear = year;
          },
        ),
      ],
    );
  }
}

/// Sheet header with title, subtitle, and done button.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.subtitle,
    required this.onDone,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, variant: AppTextVariant.title),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xs),
                  AppText(
                    subtitle!,
                    variant: AppTextVariant.body,
                    color: AppTextColor.secondary,
                  ),
                ],
              ],
            ),
          ),
          AppButton(
            label: 'Done',
            onPressed: onDone,
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
