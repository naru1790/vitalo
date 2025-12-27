import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Body & Health → Height picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
/// - Does not perform unit conversion.
abstract final class HeightPickerSheet {
  HeightPickerSheet._();

  static SheetPage page({
    required double? initialCm,
    required AppUnitSystem unitSystem,
  }) {
    return SheetPage(
      child: _HeightPickerSheetContent(
        initialCm: initialCm,
        unitSystem: unitSystem,
      ),
    );
  }
}

class _HeightPickerSheetContent extends StatefulWidget {
  const _HeightPickerSheetContent({
    required this.initialCm,
    required this.unitSystem,
  });

  final double? initialCm;
  final AppUnitSystem unitSystem;

  @override
  State<_HeightPickerSheetContent> createState() =>
      _HeightPickerSheetContentState();
}

class _HeightPickerSheetContentState extends State<_HeightPickerSheetContent> {
  // Local draft value for picker interaction only.
  // This is ephemeral UI state; persistence/validation belongs to the flow.
  late double _draftCm;

  @override
  void initState() {
    super.initState();
    _draftCm = widget.initialCm ?? 170.0;
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
              'Height',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        AppHeightPicker(
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
