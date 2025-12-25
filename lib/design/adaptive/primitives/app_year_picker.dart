// @frozen
// Tier-1 composite primitive.
// Owns: year selection semantics (min/max, age compliance, display).
// Uses: AppWheelPicker (mechanics) + AppText (typography).
// Must NOT: access platform APIs, own sheet chrome, call DateTime.now().

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../widgets/app_wheel_picker.dart';
import '../widgets/app_text.dart';
import '../../tokens/spacing.dart';

/// Tier-1 year picker composite.
///
/// Encodes birth year selection semantics:
/// - Min year constraint (default 1920)
/// - Max year = currentYear - 13 (COPPA/GDPR compliance)
/// - Descending order (recent years first)
/// - Large display of selected value
///
/// [currentYear] is REQUIRED and passed from feature code.
/// This primitive must NOT call DateTime.now().
///
/// Feature code uses this in sheet content, not standalone.
class AppYearPicker extends StatefulWidget {
  const AppYearPicker({
    super.key,
    required this.currentYear,
    this.initialYear,
    this.minYear = 1920,
    required this.onYearChanged,
  });

  /// The current calendar year. Must be provided by feature code.
  final int currentYear;

  /// Initially selected year. Defaults to currentYear - 25.
  final int? initialYear;

  /// Minimum selectable year.
  final int minYear;

  /// Called when user changes selection.
  final ValueChanged<int> onYearChanged;

  @override
  State<AppYearPicker> createState() => _AppYearPickerState();
}

class _AppYearPickerState extends State<AppYearPicker> {
  late int _maxYear;
  late List<int> _years;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Max year = 13 years ago (COPPA/GDPR minimum age)
    _maxYear = widget.currentYear - 13;

    // Build year list descending (recent first)
    _years = List.generate(
      _maxYear - widget.minYear + 1,
      (index) => _maxYear - index,
    );

    // Determine initial selection
    final effectiveInitial = widget.initialYear ?? (widget.currentYear - 25);
    final clampedYear = effectiveInitial.clamp(widget.minYear, _maxYear);
    _selectedIndex = _maxYear - clampedYear;

    // Notify parent of computed initial value (may differ from input due to clamping/defaulting)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onYearChanged(_selectedYear);
    });
  }

  @override
  void didUpdateWidget(covariant AppYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentYear != widget.currentYear ||
        oldWidget.minYear != widget.minYear ||
        oldWidget.initialYear != widget.initialYear) {
      _maxYear = widget.currentYear - 13;

      _years = List.generate(
        _maxYear - widget.minYear + 1,
        (index) => _maxYear - index,
      );

      final effectiveInitial = widget.initialYear ?? (widget.currentYear - 25);
      final clampedYear = effectiveInitial.clamp(widget.minYear, _maxYear);
      _selectedIndex = _maxYear - clampedYear;
    }
  }

  int get _selectedYear => _years[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final colors = AppColorScope.of(context).colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large value display
        AppText(
          '$_selectedYear',
          variant: AppTextVariant.display,
          color: AppTextColor.link,
        ),

        SizedBox(height: spacing.lg),

        // Wheel picker with Tier-1 semantic styling
        AppWheelPicker<int>(
          items: _years,
          selectedIndex: _selectedIndex,
          onSelectedIndexChanged: (index) {
            setState(() => _selectedIndex = index);
            widget.onYearChanged(_selectedYear);
          },
          itemBuilder: (context, year, isSelected) {
            return AppText(
              year.toString(),
              variant: isSelected ? AppTextVariant.title : AppTextVariant.body,
              color: isSelected ? AppTextColor.link : AppTextColor.secondary,
            );
          },
          // Tier-1 provides semantic styling to Tier-0
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: colors.neutralDivider,
                  width: 0.5,
                ),
              ),
              color: colors.stateSelected,
            ),
          ),
          edgeOverlay: _WheelEdgeFade(
            height: spacing.xxl,
            color: colors.surfaceElevated,
          ),
        ),
      ],
    );
  }
}

/// Gradient overlay for wheel edges.
/// Private to AppYearPicker for now; can be extracted if reuse is needed.
class _WheelEdgeFade extends StatelessWidget {
  const _WheelEdgeFade({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, color.withAlpha(0)],
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withAlpha(0), color],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
