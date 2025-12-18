import 'dart:ui';

import 'package:flutter/cupertino.dart';
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

    return showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: true,
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
    // Only allow years at least 13 years ago (minimum age: 13 for COPPA/GDPR compliance)
    _maxYear = DateTime.now().year - 13;
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
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLarge),
            ),
            border: Border(
              top: BorderSide(
                color: labelColor.withValues(alpha: 0.1),
                width: LiquidGlass.borderWidth,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with drag handle and Done button
                SheetHeader(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  onDone: () => widget.onYearSelected(_selectedYear),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Large value display - iOS HIG: Display = 48pt
                Text(
                  '$_selectedYear',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    height: 1,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Year Picker
                SizedBox(
                  height: WheelConstants.defaultHeight,
                  child: Stack(
                    children: [
                      // Year wheel
                      ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: WheelConstants.itemExtent,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: WheelConstants.diameterRatio,
                        perspective: WheelConstants.perspective,
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
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? primaryColor
                                      : secondaryLabel,
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
                      const WheelGradientOverlay(),
                    ],
                  ),
                ),

                // Bottom padding
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
