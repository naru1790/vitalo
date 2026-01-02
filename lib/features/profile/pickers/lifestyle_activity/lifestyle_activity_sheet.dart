import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../models/lifestyle_data.dart';

/// Lifestyle → Activity picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
abstract final class LifestyleActivitySheet {
  LifestyleActivitySheet._();

  static SheetPage page({required LifestyleData initialData}) {
    return SheetPage(
      child: _LifestyleActivitySheetContent(initialData: initialData),
    );
  }
}

class _LifestyleActivitySheetContent extends StatefulWidget {
  const _LifestyleActivitySheetContent({required this.initialData});

  final LifestyleData initialData;

  @override
  State<_LifestyleActivitySheetContent> createState() =>
      _LifestyleActivitySheetContentState();
}

class _LifestyleActivitySheetContentState
    extends State<_LifestyleActivitySheetContent> {
  LifestyleActivityLevel? _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialData.activityLevel;
  }

  void _toggle(LifestyleActivityLevel value) {
    setState(() {
      _draft = (_draft == value) ? null : value;
    });
  }

  void _handleSubmit() {
    Navigator.pop(context, widget.initialData.copyWith(activityLevel: _draft));
  }

  String _labelFor(LifestyleActivityLevel value) {
    return switch (value) {
      LifestyleActivityLevel.sedentary => 'Sedentary',
      LifestyleActivityLevel.lightlyActive => 'Lightly active',
      LifestyleActivityLevel.active => 'Active',
      LifestyleActivityLevel.veryActive => 'Very active',
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
              'Activity',
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
                for (final level in LifestyleActivityLevel.values)
                  AppChoiceChip(
                    label: _labelFor(level),
                    selected: _draft == level,
                    onSelected: () => _toggle(level),
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
