import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'wheel_picker.dart';

/// A styled bottom sheet with a year picker.
/// Matches Vitalo's soft minimalistic design language.
class YearPickerSheet extends StatefulWidget {
  const YearPickerSheet({
    super.key,
    required this.initialYear,
    required this.onYearSelected,
    this.minYear = 1920,
    this.title = 'Birth Year',
    this.subtitle = 'For age-based health insights',
  });

  /// The initially selected year.
  final int initialYear;

  /// Callback when a year is confirmed.
  final ValueChanged<int> onYearSelected;

  /// Minimum selectable year.
  final int minYear;

  /// Title displayed in the header.
  final String title;

  /// Subtitle/helper text.
  final String subtitle;

  /// Shows the year picker as a modal bottom sheet.
  static Future<int?> show({
    required BuildContext context,
    int? initialYear,
    int minYear = 1920,
    String title = 'Birth Year',
    String subtitle = 'For age-based health insights',
  }) async {
    final currentYear = DateTime.now().year;
    final effectiveInitialYear = initialYear ?? (currentYear - 25);

    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => YearPickerSheet(
        initialYear: effectiveInitialYear,
        minYear: minYear,
        title: title,
        subtitle: subtitle,
        onYearSelected: (year) => Navigator.pop(context, year),
      ),
    );
  }

  @override
  State<YearPickerSheet> createState() => _YearPickerSheetState();
}

class _YearPickerSheetState extends State<YearPickerSheet> {
  late int _selectedYear;
  late FixedExtentScrollController _scrollController;
  late int _maxYear;

  @override
  void initState() {
    super.initState();
    // Only allow years at least 3 years ago (minimum age: 3)
    _maxYear = DateTime.now().year - 3;
    _selectedYear = widget.initialYear.clamp(widget.minYear, _maxYear);

    // Calculate initial scroll position (years go from max to min, descending)
    final initialIndex = _maxYear - _selectedYear;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _yearCount => _maxYear - widget.minYear + 1;

  int _indexToYear(int index) => _maxYear - index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          widget.subtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Done button
                  FilledButton(
                    onPressed: () => widget.onYearSelected(_selectedYear),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Large value display
            Text(
              '$_selectedYear',
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                height: 1,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Year Picker
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  // Year wheel
                  ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 50,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    perspective: 0.003,
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedYear = _indexToYear(index));
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _yearCount,
                      builder: (context, index) {
                        final year = _indexToYear(index);
                        final isSelected = year == _selectedYear;
                        return Center(
                          child: Text(
                            year.toString(),
                            style: textTheme.headlineMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Arrow indicators
                  Positioned(
                    left: AppSpacing.lg,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: WheelArrowIndicator(
                        direction: ArrowDirection.right,
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppSpacing.lg,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: WheelArrowIndicator(
                        direction: ArrowDirection.left,
                      ),
                    ),
                  ),

                  // Gradient fades
                  IgnorePointer(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.surface,
                                  colorScheme.surface.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.surface.withValues(alpha: 0),
                                  colorScheme.surface,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom padding
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
