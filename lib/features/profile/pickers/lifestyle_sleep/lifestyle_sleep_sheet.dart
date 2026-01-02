import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../models/lifestyle_data.dart';

/// Lifestyle → Sleep picker sheet.
///
/// Sheet content only.
/// - Uses [SheetPage] for structure.
/// - Does not detect platform.
abstract final class LifestyleSleepSheet {
  LifestyleSleepSheet._();

  static SheetPage page({required LifestyleData initialData}) {
    return SheetPage(
      child: _LifestyleSleepSheetContent(initialData: initialData),
    );
  }
}

class _LifestyleSleepSheetContent extends StatefulWidget {
  const _LifestyleSleepSheetContent({required this.initialData});

  final LifestyleData initialData;

  @override
  State<_LifestyleSleepSheetContent> createState() =>
      _LifestyleSleepSheetContentState();
}

class _LifestyleSleepSheetContentState
    extends State<_LifestyleSleepSheetContent> {
  Duration? _draftSleepDuration;
  Duration? _draftBedTime;

  @override
  void initState() {
    super.initState();
    _draftSleepDuration = widget.initialData.sleepDuration;
    _draftBedTime = widget.initialData.bedTime;
  }

  void _toggleSleepDuration(Duration value) {
    setState(() {
      _draftSleepDuration = (_draftSleepDuration == value) ? null : value;
    });
  }

  void _toggleBedTime(Duration value) {
    setState(() {
      _draftBedTime = (_draftBedTime == value) ? null : value;
    });
  }

  void _handleSubmit() {
    Navigator.pop(
      context,
      widget.initialData.copyWith(
        sleepDuration: _draftSleepDuration,
        bedTime: _draftBedTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    const sleepOptions = <Duration>[
      Duration(hours: 6),
      Duration(hours: 7),
      Duration(hours: 8),
      Duration(hours: 9),
    ];

    const bedTimeOptions = <Duration>[
      Duration(hours: 21),
      Duration(hours: 22),
      Duration(hours: 23),
      Duration(hours: 0),
    ];

    String sleepLabel(Duration d) => '${d.inHours}h';

    String bedTimeLabel(Duration d) {
      final totalMinutes = d.inMinutes % (24 * 60);
      final hour24 = totalMinutes ~/ 60;
      final minute = totalMinutes % 60;

      final isPm = hour24 >= 12;
      final hour12 = (hour24 % 12 == 0) ? 12 : hour24 % 12;
      final mm = minute.toString().padLeft(2, '0');
      final suffix = isPm ? 'PM' : 'AM';

      return '$hour12:$mm $suffix';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Sleep',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        AppSurface(
          variant: AppSurfaceVariant.card,
          child: AppSurfaceBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppText(
                  'Sleep Duration',
                  variant: AppTextVariant.label,
                  color: AppTextColor.secondary,
                ),
                SizedBox(height: spacing.sm),
                Wrap(
                  spacing: spacing.sm,
                  runSpacing: spacing.sm,
                  children: [
                    for (final opt in sleepOptions)
                      AppChoiceChip(
                        label: sleepLabel(opt),
                        selected: _draftSleepDuration == opt,
                        onSelected: () => _toggleSleepDuration(opt),
                      ),
                  ],
                ),
                SizedBox(height: spacing.lg),
                const AppText(
                  'Bedtime',
                  variant: AppTextVariant.label,
                  color: AppTextColor.secondary,
                ),
                SizedBox(height: spacing.sm),
                Wrap(
                  spacing: spacing.sm,
                  runSpacing: spacing.sm,
                  children: [
                    for (final opt in bedTimeOptions)
                      AppChoiceChip(
                        label: bedTimeLabel(opt),
                        selected: _draftBedTime == opt,
                        onSelected: () => _toggleBedTime(opt),
                      ),
                  ],
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
