// =============================================================================
// LIFESTYLE SECTION - Activity, Sleep & Diet
// =============================================================================
// Consolidated lifestyle settings: activity level, bedtime, sleep duration,
// and dietary preferences. Follows soft minimalist design language.
// =============================================================================

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';

import '../theme.dart';
import 'profile_row.dart';
import 'dietary_preferences_sheet.dart';
import 'wheel_picker.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY LEVEL - Category-based for easy correlation
// ─────────────────────────────────────────────────────────────────────────────

/// Activity level categories based on relatable daily routines
enum ActivityLevel {
  deskBound(
    'Desk Bound',
    'Student, office work, remote job — mostly sitting with minimal movement',
    CupertinoIcons.desktopcomputer,
    ActivityColors.deskBound,
    1.2,
  ),
  lightlyActive(
    'Lightly Active',
    'Teacher, retail, homemaker — on your feet with some walking',
    CupertinoIcons.person_2_fill,
    ActivityColors.lightlyActive,
    1.4,
  ),
  activeLifestyle(
    'Active Lifestyle',
    'Delivery, warehouse, healthcare — regular physical movement',
    CupertinoIcons.cube_box_fill,
    ActivityColors.activeLifestyle,
    1.6,
  ),
  veryActive(
    'Very Active',
    'Construction, farming, athlete — intense daily physical activity',
    CupertinoIcons.flame_fill,
    ActivityColors.veryActive,
    1.8,
  );

  const ActivityLevel(
    this.label,
    this.description,
    this.icon,
    this.color,
    this.multiplier,
  );

  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final double multiplier; // For TDEE calculation
}

// ─────────────────────────────────────────────────────────────────────────────
// LIFESTYLE DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

/// Result from lifestyle card selections
class LifestyleData {
  const LifestyleData({
    this.activityLevel,
    this.bedTime,
    this.sleepDurationMinutes,
    this.dietaryPreferences,
  });

  final ActivityLevel? activityLevel;
  final TimeOfDay? bedTime;
  final int? sleepDurationMinutes; // Store as minutes for precision
  final DietaryPreferencesResult? dietaryPreferences;

  LifestyleData copyWith({
    ActivityLevel? activityLevel,
    TimeOfDay? bedTime,
    int? sleepDurationMinutes,
    DietaryPreferencesResult? dietaryPreferences,
  }) {
    return LifestyleData(
      activityLevel: activityLevel ?? this.activityLevel,
      bedTime: bedTime ?? this.bedTime,
      sleepDurationMinutes: sleepDurationMinutes ?? this.sleepDurationMinutes,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
    );
  }

  /// Format sleep duration as "Xh Ym"
  String get formattedSleepDuration {
    if (sleepDurationMinutes == null) return '—';
    final hours = sleepDurationMinutes! ~/ 60;
    final mins = sleepDurationMinutes! % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  /// Format bed time as "10:30 PM"
  String formatBedTime(BuildContext context) {
    if (bedTime == null) return '—';
    return bedTime!.format(context);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LIFESTYLE CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Lifestyle section with activity, sleep, and diet preferences
class LifestyleCard extends StatelessWidget {
  const LifestyleCard({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  final LifestyleData data;
  final ValueChanged<LifestyleData> onDataChanged;

  Future<void> _selectActivityLevel(BuildContext context) async {
    final result = await _ActivityLevelSheet.show(
      context: context,
      initialValue: data.activityLevel,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(activityLevel: result));
    }
  }

  Future<void> _selectBedTime(BuildContext context) async {
    final result = await _BedTimeSheet.show(
      context: context,
      initialTime: data.bedTime,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(bedTime: result));
    }
  }

  Future<void> _selectSleepDuration(BuildContext context) async {
    final result = await _SleepDurationSheet.show(
      context: context,
      initialMinutes: data.sleepDurationMinutes,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(sleepDurationMinutes: result));
    }
  }

  Future<void> _selectDietaryPreferences(BuildContext context) async {
    final result = await DietaryPreferencesSheet.show(
      context: context,
      initialResult: data.dietaryPreferences,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(dietaryPreferences: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final hasDietPref = data.dietaryPreferences != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xxs),
          child: Text(
            'Lifestyle',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // All lifestyle rows in a single card
        ProfileCard(
          child: Column(
            children: [
              ProfileTappableRow(
                icon: CupertinoIcons.flame_fill,
                label: 'Activity Level',
                value: data.activityLevel?.label ?? '—',
                onTap: () => _selectActivityLevel(context),
              ),
              const ProfileRowDivider(),
              ProfileTappableRow(
                icon: CupertinoIcons.moon_fill,
                label: 'Bed Time',
                value: data.formatBedTime(context),
                onTap: () => _selectBedTime(context),
              ),
              const ProfileRowDivider(),
              ProfileTappableRow(
                icon: CupertinoIcons.bed_double_fill,
                label: 'Sleep Duration',
                value: data.formattedSleepDuration,
                onTap: () => _selectSleepDuration(context),
              ),
              const ProfileRowDivider(),
              ProfileTappableRow(
                icon: CupertinoIcons.square_list_fill,
                label: 'Dietary Preferences',
                value: hasDietPref ? null : 'Set up',
                subtitle: hasDietPref
                    ? data.dietaryPreferences!.displayText
                    : null,
                onTap: () => _selectDietaryPreferences(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY LEVEL SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityLevelSheet extends StatefulWidget {
  final ActivityLevel? initialValue;

  const _ActivityLevelSheet({this.initialValue});

  static Future<ActivityLevel?> show({
    required BuildContext context,
    ActivityLevel? initialValue,
  }) {
    return showCupertinoModalPopup<ActivityLevel>(
      context: context,
      builder: (context) => _ActivityLevelSheet(initialValue: initialValue),
    );
  }

  @override
  State<_ActivityLevelSheet> createState() => _ActivityLevelSheetState();
}

class _ActivityLevelSheetState extends State<_ActivityLevelSheet> {
  ActivityLevel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _confirm() {
    if (_selected != null) {
      Navigator.pop(context, _selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? surfaceColor.withValues(alpha: 0.85)
                : surfaceColor.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLarge),
            ),
            border: Border(
              top: BorderSide(
                color: separatorColor.withValues(alpha: 0.2),
                width: LiquidGlass.borderWidth,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with drag handle and Done button
                SheetHeader(
                  title: 'Activity Level',
                  subtitle: 'Choose what best describes your typical day',
                  onDone: _confirm,
                  doneEnabled: _selected != null,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Activity level options as cards
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: ActivityLevel.values.map((level) {
                      final isSelected = _selected == level;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _ActivityLevelCard(
                          level: level,
                          isSelected: isSelected,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selected = level);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityLevelCard extends StatelessWidget {
  final ActivityLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityLevelCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final activityColor = level.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.15)
              : tertiaryFill,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected ? primaryColor : separatorColor,
            width: isSelected ? 1.5 : LiquidGlass.borderWidth,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: activityColor.withValues(alpha: isSelected ? 1.0 : 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
              ),
              child: Icon(
                level.icon,
                color: isSelected ? CupertinoColors.white : activityColor,
                size: AppSpacing.iconSize,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.8)
                          : secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: primaryColor,
                size: AppSpacing.iconSize,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BED TIME SHEET - Alarm clock style
// ─────────────────────────────────────────────────────────────────────────────

class _BedTimeSheet extends StatefulWidget {
  final TimeOfDay? initialTime;

  const _BedTimeSheet({this.initialTime});

  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) {
    return showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (context) => _BedTimeSheet(initialTime: initialTime),
    );
  }

  @override
  State<_BedTimeSheet> createState() => _BedTimeSheetState();
}

class _BedTimeSheetState extends State<_BedTimeSheet> {
  late int _hour; // 0-11 for display
  late int _minute;
  late bool _isPM;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  // Default ideal bedtime: 10:30 PM
  static const _defaultHour = 10;
  static const _defaultMinute = 30;
  static const _defaultIsPM = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      final h24 = widget.initialTime!.hour;
      _isPM = h24 >= 12;
      _hour = h24 % 12; // 0-11
      _minute = widget.initialTime!.minute;
    } else {
      _hour = _defaultHour;
      _minute = _defaultMinute;
      _isPM = _defaultIsPM;
    }

    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  TimeOfDay get _selectedTime {
    // Convert 0-12 hour to 24-hour format
    int h24;
    if (_isPM) {
      // PM: 0=12 PM, 1=1 PM, ..., 12=12 AM (midnight)
      if (_hour == 0) {
        h24 = 12; // 0 PM = 12 PM (noon)
      } else if (_hour == 12) {
        h24 = 0; // 12 PM = 12 AM (midnight)
      } else {
        h24 = _hour + 12; // 1-11 PM
      }
    } else {
      // AM: 0=12 AM, 1=1 AM, ..., 12=12 PM
      if (_hour == 12) {
        h24 = 12; // 12 AM = 12 PM (noon)
      } else {
        h24 = _hour; // 0-11 AM
      }
    }
    return TimeOfDay(hour: h24, minute: _minute);
  }

  String get _formattedTime {
    // Display as selected format (0-12)
    final hourStr = _hour.toString().padLeft(2, '0');
    final minuteStr = _minute.toString().padLeft(2, '0');
    final period = _isPM ? 'PM' : 'AM';
    return '$hourStr:$minuteStr $period';
  }

  void _confirm() {
    Navigator.pop(context, _selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? surfaceColor.withValues(alpha: 0.85)
                : surfaceColor.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLarge),
            ),
            border: Border(
              top: BorderSide(
                color: separatorColor.withValues(alpha: 0.2),
                width: LiquidGlass.borderWidth,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with drag handle and Done button
                SheetHeader(
                  title: 'Bed Time',
                  subtitle: 'When do you usually go to sleep?',
                  onDone: _confirm,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Large value display
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // AM/PM toggle using unified design
                WheelUnitToggle(
                  options: const ['AM', 'PM'],
                  selectedIndex: _isPM ? 1 : 0,
                  onChanged: (index) {
                    HapticFeedback.selectionClick();
                    setState(() => _isPM = index == 1);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Headers for hour and minute - outside wheel area
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg + 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'hr',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'min',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                // Time picker wheels with arrow indicators
                SizedBox(
                  height: WheelConstants.defaultHeight,
                  child: Stack(
                    children: [
                      // Wheels row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg + 12,
                        ),
                        child: Row(
                          children: [
                            // Hour wheel (12, 1, 2, ..., 11)
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                controller: _hourController,
                                itemExtent: WheelConstants.itemExtent,
                                physics: const FixedExtentScrollPhysics(),
                                diameterRatio: WheelConstants.diameterRatio,
                                perspective: WheelConstants.perspective,
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _hour = index);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 13, // 0, 1, 2, ..., 12
                                  builder: (context, index) {
                                    final isSelected = index == _hour;
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: isSelected
                                              ? primaryColor
                                              : secondaryLabel,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Minute wheel (00-59)
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                controller: _minuteController,
                                itemExtent: WheelConstants.itemExtent,
                                physics: const FixedExtentScrollPhysics(),
                                diameterRatio: WheelConstants.diameterRatio,
                                perspective: WheelConstants.perspective,
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _minute = index);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 60,
                                  builder: (context, index) {
                                    final isSelected = index == _minute;
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: isSelected
                                              ? primaryColor
                                              : secondaryLabel,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow indicators - outer edges
                      const Positioned(
                        left: AppSpacing.lg,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: WheelArrowIndicator(
                            direction: ArrowDirection.right,
                          ),
                        ),
                      ),
                      const Positioned(
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
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLEEP DURATION SHEET - Vertical ruler picker
// ─────────────────────────────────────────────────────────────────────────────

class _SleepDurationSheet extends StatefulWidget {
  final int? initialMinutes;

  const _SleepDurationSheet({this.initialMinutes});

  static Future<int?> show({
    required BuildContext context,
    int? initialMinutes,
  }) {
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (context) => _SleepDurationSheet(initialMinutes: initialMinutes),
    );
  }

  @override
  State<_SleepDurationSheet> createState() => _SleepDurationSheetState();
}

class _SleepDurationSheetState extends State<_SleepDurationSheet> {
  late int _hours;
  late int _minutes;

  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;

  // Default: 8 hours
  static const _defaultHours = 8;
  static const _defaultMinutes = 0;

  // Range: 0-23 hours
  static const _minHours = 0;
  static const _maxHours = 23;

  @override
  void initState() {
    super.initState();
    if (widget.initialMinutes != null) {
      _hours = (widget.initialMinutes! ~/ 60).clamp(_minHours, _maxHours);
      _minutes = widget.initialMinutes! % 60;
    } else {
      _hours = _defaultHours;
      _minutes = _defaultMinutes;
    }

    _hoursController = FixedExtentScrollController(initialItem: _hours);
    _minutesController = FixedExtentScrollController(initialItem: _minutes);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  int get _totalMinutes => _hours * 60 + _minutes;

  void _confirm() {
    Navigator.pop(context, _totalMinutes);
  }

  String get _formattedDuration {
    if (_minutes == 0) return '$_hours hrs';
    return '$_hours hrs $_minutes mins';
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? surfaceColor.withValues(alpha: 0.85)
                : surfaceColor.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLarge),
            ),
            border: Border(
              top: BorderSide(
                color: separatorColor.withValues(alpha: 0.2),
                width: LiquidGlass.borderWidth,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with drag handle and Done button
                SheetHeader(
                  title: 'Sleep Duration',
                  subtitle: 'How long do you usually sleep?',
                  onDone: _confirm,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Large duration display
                Text(
                  _formattedDuration,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    height: 1,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Headers for hours and minutes
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg + 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'hr',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'min',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                // Duration picker wheels with arrow indicators
                SizedBox(
                  height: WheelConstants.defaultHeight,
                  child: Stack(
                    children: [
                      // Wheels
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg + 12,
                        ),
                        child: Row(
                          children: [
                            // Hours wheel (00-23)
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                controller: _hoursController,
                                itemExtent: WheelConstants.itemExtent,
                                physics: const FixedExtentScrollPhysics(),
                                diameterRatio: WheelConstants.diameterRatio,
                                perspective: WheelConstants.perspective,
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _hours = index);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: _maxHours + 1, // 0-23
                                  builder: (context, index) {
                                    final isSelected = index == _hours;
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: isSelected
                                              ? primaryColor
                                              : secondaryLabel,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Minutes wheel (00-59)
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                controller: _minutesController,
                                itemExtent: WheelConstants.itemExtent,
                                physics: const FixedExtentScrollPhysics(),
                                diameterRatio: WheelConstants.diameterRatio,
                                perspective: WheelConstants.perspective,
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _minutes = index);
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 60, // 0-59
                                  builder: (context, index) {
                                    final isSelected = index == _minutes;
                                    return Center(
                                      child: Text(
                                        index.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: isSelected
                                              ? primaryColor
                                              : secondaryLabel,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow indicators - outer edges
                      const Positioned(
                        left: AppSpacing.lg,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: WheelArrowIndicator(
                            direction: ArrowDirection.right,
                          ),
                        ),
                      ),
                      const Positioned(
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
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
