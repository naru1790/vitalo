import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Body Measurements → Waist picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
/// - Does not perform unit conversion.
abstract final class WaistPickerSheet {
  WaistPickerSheet._();

  static SheetPage page({
    required double? initialCm,
    required AppUnitSystem unitSystem,
  }) {
    return SheetPage(
      child: _WaistPickerSheetContent(
        initialCm: initialCm,
        unitSystem: unitSystem,
      ),
    );
  }
}

class _WaistPickerSheetContent extends StatefulWidget {
  const _WaistPickerSheetContent({
    required this.initialCm,
    required this.unitSystem,
  });

  final double? initialCm;
  final AppUnitSystem unitSystem;

  @override
  State<_WaistPickerSheetContent> createState() =>
      _WaistPickerSheetContentState();
}

class _WaistPickerSheetContentState extends State<_WaistPickerSheetContent> {
  // Local draft value for picker interaction only.
  // This is ephemeral UI state; persistence/validation belongs to the flow.
  late double _draftCm;

  @override
  void initState() {
    super.initState();
    _draftCm = widget.initialCm ?? 80.0;
  }

  void _handleSubmit() {
    Navigator.pop(context, _draftCm);
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
              'Waist',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        AppWaistPicker(
          initialCm: _draftCm,
          unitSystem: widget.unitSystem,
          onChanged: (cm) {
            setState(() => _draftCm = cm);
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
