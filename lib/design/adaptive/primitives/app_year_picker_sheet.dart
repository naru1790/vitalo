// @adaptive-composite
// Semantics: Year picker sheet content
// Owns: sheet-level year selection UX
// Emits: selected year via Navigator.pop
// Must NOT:
//  - fetch user data
//  - navigate routes (except pop with value)
//  - show global feedback (snackbars, toasts, dialogs)
//  - use Expanded, Spacer, or other constraint-unsafe widgets

import 'package:flutter/widgets.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import 'app_year_picker.dart';
import '../../tokens/spacing.dart';

/// Sheet content for year selection.
///
/// This is pure sheet content — all layout/structure is owned by [SheetPage].
/// Uses [Column] with [mainAxisSize: MainAxisSize.min] to be constraint-safe.
///
/// Returns the selected year via `Navigator.pop(context, year)`.
class AppYearPickerSheet extends StatefulWidget {
  const AppYearPickerSheet({
    super.key,
    required this.initialYear,
    this.title = 'Birth Year',
  });

  /// The initially selected year.
  final int initialYear;

  /// Title displayed at the top of the sheet.
  final String title;

  @override
  State<AppYearPickerSheet> createState() => _AppYearPickerSheetState();
}

class _AppYearPickerSheetState extends State<AppYearPickerSheet> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
  }

  void _handleConfirm() {
    Navigator.pop(context, _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    // CONSTRAINT-SAFE layout:
    // - Column with mainAxisSize.min
    // - No Expanded, Spacer, or Align(center) with unbounded constraints
    // - All children have intrinsic or explicit sizing
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        _SheetHeader(title: widget.title),

        SizedBox(height: spacing.md),

        // Year picker wheel
        AppYearPicker(
          selectedYear: _selectedYear,
          onYearChanged: (year) {
            setState(() => _selectedYear = year);
          },
        ),

        SizedBox(height: spacing.lg),

        // Confirm button
        AppButton(
          label: 'Confirm',
          variant: AppButtonVariant.primary,
          onPressed: _handleConfirm,
        ),
      ],
    );
  }
}

/// Header row for the sheet.
///
/// Constraint-safe: uses Row with MainAxisAlignment, not Expanded.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          title,
          variant: AppTextVariant.title,
          color: AppTextColor.primary,
        ),
      ],
    );
  }
}
