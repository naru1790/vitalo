// @frozen
// Tier-1 composite primitive.
// Owns: year picker with COPPA/GDPR compliance logic + visual styling.
// Uses: AppWheelPicker (Tier-0).
// Must NOT: call DateTime.now(), read AppPlatformScope, perform navigation.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../widgets/app_text.dart';
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
/// ## Tier-1 Owns
/// - COPPA/GDPR age validation
/// - Visual styling (text, colors, overlays)
/// - Selection state visual encoding
///
/// ## Tier-1 Must Receive
/// - [currentYear] — injected by feature code (not DateTime.now())
/// - [diameterRatio] — resolved by caller based on platform
///
/// ## Usage
/// ```dart
/// AppYearPicker(
///   currentYear: DateTime.now().year, // Feature code resolves time
///   selectedYear: 1990,
///   onYearChanged: (year) => print('Selected: $year'),
///   diameterRatio: platform == AppPlatform.ios ? 1.5 : 2.0,
/// )
/// ```
class AppYearPicker extends StatefulWidget {
  const AppYearPicker({
    super.key,
    required this.currentYear,
    required this.selectedYear,
    required this.onYearChanged,
    this.minimumAge = _kMinimumAge,
    this.maxAgeRange = 100,
    this.height = 200.0,
    this.diameterRatio = 1.5,
  });

  /// The current calendar year.
  ///
  /// Must be injected by feature code. Tier-1 does NOT call DateTime.now().
  final int currentYear;

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

  /// Diameter ratio for wheel curvature.
  ///
  /// Must be resolved by caller based on platform.
  /// Tier-1 does NOT read AppPlatformScope.
  /// Typical values: iOS 1.5, Android 2.0.
  final double diameterRatio;

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
    if (widget.currentYear != oldWidget.currentYear ||
        widget.minimumAge != oldWidget.minimumAge ||
        widget.maxAgeRange != oldWidget.maxAgeRange) {
      _buildYearList();
      _selectedIndex = _findSelectedIndex();
    }
    if (widget.selectedYear != oldWidget.selectedYear) {
      _selectedIndex = _findSelectedIndex();
    }
  }

  void _buildYearList() {
    final maxYear = widget.currentYear - widget.minimumAge;
    final minYear = widget.currentYear - widget.maxAgeRange;

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
    final colors = AppColorScope.of(context).colors;

    return AppWheelPicker<int>(
      items: _years,
      selectedIndex: _selectedIndex,
      onSelectedItemChanged: (index) {
        setState(() => _selectedIndex = index);
        widget.onYearChanged(_years[index]);
      },
      itemBuilder: (context, year, isSelected) => Center(
        child: AppText(
          year.toString(),
          // Visual encoding of selection state
          variant: isSelected ? AppTextVariant.title : AppTextVariant.body,
          color: isSelected ? AppTextColor.primary : AppTextColor.secondary,
        ),
      ),
      selectionOverlay: _SelectionOverlay(color: colors.neutralDivider),
      edgeOverlay: _EdgeFadeOverlay(
        color: colors.surfaceElevated,
        height: widget.height,
      ),
      height: widget.height,
      diameterRatio: widget.diameterRatio,
    );
  }
}

/// Selection highlight band with top/bottom borders.
class _SelectionOverlay extends StatelessWidget {
  const _SelectionOverlay({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: color, width: 1.0),
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Edge fade gradients (top and bottom).
///
/// Uses Stack + Positioned for constraint safety.
/// Does NOT use Column + Spacer.
class _EdgeFadeOverlay extends StatelessWidget {
  const _EdgeFadeOverlay({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fadeHeight = height * 0.3;

    return Stack(
      children: [
        // Top fade gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: fadeHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, color.withValues(alpha: 0.0)],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
        // Bottom fade gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: fadeHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [color, color.withValues(alpha: 0.0)],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}
