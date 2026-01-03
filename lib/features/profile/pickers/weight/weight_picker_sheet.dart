import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Body Measurements → Weight picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
/// - Does not perform unit conversion.
abstract final class WeightPickerSheet {
  WeightPickerSheet._();

  static SheetPage page({
    required double? initialKg,
    required AppUnitSystem unitSystem,
  }) {
    return SheetPage(
      child: _WeightPickerSheetContent(
        initialKg: initialKg,
        unitSystem: unitSystem,
      ),
    );
  }
}

class _WeightPickerSheetContent extends StatefulWidget {
  const _WeightPickerSheetContent({
    required this.initialKg,
    required this.unitSystem,
  });

  final double? initialKg;
  final AppUnitSystem unitSystem;

  @override
  State<_WeightPickerSheetContent> createState() =>
      _WeightPickerSheetContentState();
}

class _WeightPickerSheetContentState extends State<_WeightPickerSheetContent> {
  // Local draft value for picker interaction only.
  // This is ephemeral UI state; persistence/validation belongs to the flow.
  late double _draftKg;

  @override
  void initState() {
    super.initState();
    _draftKg = widget.initialKg ?? 70.0;
  }

  void _handleSubmit() {
    Navigator.pop(context, _draftKg);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Weight',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        AppWeightPicker(
          initialKg: _draftKg,
          unitSystem: widget.unitSystem,
          onChanged: (kg) {
            setState(() => _draftKg = kg);
          },
        ),
        SizedBox(height: spacing.lg),
        AppButton(
          label: 'Done',
          variant: AppButtonVariant.primary,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
