import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../models/lifestyle_data.dart';

/// Lifestyle → Diet picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
abstract final class LifestyleDietSheet {
  LifestyleDietSheet._();

  static SheetPage page({required LifestyleData initialData}) {
    return SheetPage(
      child: _LifestyleDietSheetContent(initialData: initialData),
    );
  }
}

class _LifestyleDietSheetContent extends StatefulWidget {
  const _LifestyleDietSheetContent({required this.initialData});

  final LifestyleData initialData;

  @override
  State<_LifestyleDietSheetContent> createState() =>
      _LifestyleDietSheetContentState();
}

class _LifestyleDietSheetContentState
    extends State<_LifestyleDietSheetContent> {
  DietPreference? _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialData.dietPreference;
  }

  void _toggle(DietPreference value) {
    setState(() {
      _draft = (_draft == value) ? null : value;
    });
  }

  void _handleSubmit() {
    Navigator.pop(context, widget.initialData.copyWith(dietPreference: _draft));
  }

  String _labelFor(DietPreference value) {
    return switch (value) {
      DietPreference.omnivore => 'Omnivore',
      DietPreference.vegetarian => 'Vegetarian',
      DietPreference.vegan => 'Vegan',
      DietPreference.pescatarian => 'Pescatarian',
    };
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
              'Diet',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        AppSurface(
          variant: AppSurfaceVariant.card,
          child: AppSurfaceBody(
            child: Wrap(
              spacing: spacing.sm,
              runSpacing: spacing.sm,
              children: [
                for (final pref in DietPreference.values)
                  AppChoiceChip(
                    label: _labelFor(pref),
                    selected: _draft == pref,
                    onSelected: () => _toggle(pref),
                  ),
              ],
            ),
          ),
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
