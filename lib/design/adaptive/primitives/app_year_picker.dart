// @frozen
// Tier-1 composite primitive.
// Owns: year picker with COPPA/GDPR compliance logic.
// Uses: AppWheelPicker (Tier-0).
// Must NOT: access platform APIs, perform navigation, show feedback.

import 'package:flutter/widgets.dart';

import '../widgets/app_wheel_picker.dart';

/// COPPA/GDPR minimum age threshold.
///
/// Users must be at least this old to use the app.
/// This is a legal compliance requirement, not a UX choice.
const int _kMinimumAge = 13;

/// Tier-1 year picker composite.
///
/// Provides a year selection wheel with age compliance built-in.
/// Automatically calculates valid year range based on [minimumAge].
///
/// This widget is constraint-safe and works correctly inside
/// modal sheets including iOS's showCupertinoModalPopup.
///
/// ## Usage
/// ```dart
/// AppYearPicker(
///   selectedYear: 1990,
///   onYearChanged: (year) => print('Selected: $year'),
/// )
/// ```
class AppYearPicker extends StatefulWidget {
  const AppYearPicker({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    this.minimumAge = _kMinimumAge,
    this.maxAgeRange = 100,
    this.height = 200.0,
  });

  /// The currently selected year.
  final int selectedYear;

  /// Called when the selected year changes.
  final ValueChanged<int> onYearChanged;

  /// Minimum age allowed (default: 13 for COPPA/GDPR compliance).
  final int minimumAge;

  /// Maximum age range to show (default: 100 years back).
  final int maxAgeRange;

  /// Height of the picker widget.
  final double height;

  @override
  State<AppYearPicker> createState() => _AppYearPickerState();
}

class _AppYearPickerState extends State<AppYearPicker> {
  late List<int> _years;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _buildYearList();
    _selectedIndex = _findSelectedIndex();
  }

  @override
  void didUpdateWidget(AppYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minimumAge != oldWidget.minimumAge ||
        widget.maxAgeRange != oldWidget.maxAgeRange) {
      _buildYearList();
    }
    if (widget.selectedYear != oldWidget.selectedYear) {
      _selectedIndex = _findSelectedIndex();
    }
  }

  void _buildYearList() {
    final currentYear = DateTime.now().year;
    final maxYear = currentYear - widget.minimumAge;
    final minYear = currentYear - widget.maxAgeRange;

    // Build years in descending order (newest first)
    _years = List.generate(maxYear - minYear + 1, (index) => maxYear - index);
  }

  int _findSelectedIndex() {
    final index = _years.indexOf(widget.selectedYear);
    // If selected year is not in range, default to middle of list
    if (index < 0) {
      return _years.length ~/ 2;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return AppWheelPicker<int>(
      items: _years,
      selectedIndex: _selectedIndex,
      onSelectedItemChanged: (index) {
        setState(() => _selectedIndex = index);
        widget.onYearChanged(_years[index]);
      },
      itemLabelBuilder: (year) => year.toString(),
      height: widget.height,
    );
  }
}
