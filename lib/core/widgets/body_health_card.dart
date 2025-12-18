// =============================================================================
// BODY & HEALTH SECTION - Soft Minimalist Design
// =============================================================================
// Matches the standard profile section design (same as Personal Info, etc.)
// Uses WheelPicker for waist measurement (Cupertino-style wheel).
// Follows dietary preferences pattern for "+Other" chip with inline input.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalo/core/theme.dart';
import 'package:vitalo/core/widgets/app_segmented_button.dart';
import 'package:vitalo/core/widgets/height_picker_sheet.dart';
import 'package:vitalo/core/widgets/profile_row.dart';
import 'package:vitalo/core/widgets/weight_picker_sheet.dart';
import 'package:vitalo/core/widgets/wheel_picker.dart';

/// Predefined health conditions with simple, user-friendly labels
/// Focus on conditions that significantly impact diet/nutrition recommendations
enum HealthCondition {
  none('I\'m healthy', null),
  // Metabolic conditions
  diabetes('Diabetes (Type 2)', Icons.bloodtype_outlined),
  preDiabetes('Pre-diabetic', Icons.bloodtype_outlined),
  highBP('High Blood Pressure', Icons.favorite_border),
  cholesterol('High Cholesterol', Icons.analytics_outlined),
  // Hormonal conditions
  thyroid('Thyroid Issues', Icons.monitor_heart_outlined),
  pcos('PCOS', Icons.female),
  // Kidney & Liver
  kidneyDisease('Kidney Disease', Icons.water_drop_outlined),
  fattyLiver('Fatty Liver', Icons.healing_outlined),
  // Heart
  heartDisease('Heart Disease', Icons.monitor_heart_outlined),
  // Female-specific conditions
  pregnant('Pregnant', Icons.pregnant_woman),
  lactating('Breastfeeding', Icons.child_care);

  const HealthCondition(this.label, this.icon);
  final String label;
  final IconData? icon;

  /// Returns true if this is a female-only condition
  bool get isFemaleOnly => this == pregnant || this == lactating;
}

/// Result from body & health card
class BodyHealthData {
  const BodyHealthData({
    this.weightKg,
    this.heightCm,
    this.waistCm,
    this.conditions = const {},
    this.customConditions = const [],
    this.isMetric = true,
  });

  final double? weightKg;
  final double? heightCm;
  final double? waistCm;
  final Set<HealthCondition> conditions;
  final List<String> customConditions;
  final bool isMetric;

  BodyHealthData copyWith({
    double? weightKg,
    double? heightCm,
    double? waistCm,
    Set<HealthCondition>? conditions,
    List<String>? customConditions,
    bool? isMetric,
  }) {
    return BodyHealthData(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
      conditions: conditions ?? this.conditions,
      customConditions: customConditions ?? this.customConditions,
      isMetric: isMetric ?? this.isMetric,
    );
  }

  bool get hasNoConditions =>
      conditions.isEmpty ||
      (conditions.length == 1 && conditions.contains(HealthCondition.none));
}

/// Body & Health section following standard profile section design
class BodyHealthCard extends StatefulWidget {
  const BodyHealthCard({
    super.key,
    required this.data,
    required this.onDataChanged,
    this.isFemale = false,
  });

  final BodyHealthData data;
  final ValueChanged<BodyHealthData> onDataChanged;
  final bool isFemale;

  @override
  State<BodyHealthCard> createState() => _BodyHealthCardState();
}

class _BodyHealthCardState extends State<BodyHealthCard> {
  @override
  void dispose() {
    super.dispose();
  }

  String _formatWeight() {
    if (widget.data.weightKg == null) return '—';
    if (widget.data.isMetric) {
      return '${widget.data.weightKg!.toStringAsFixed(1)} kg';
    } else {
      final lbs = widget.data.weightKg! * 2.20462;
      return '${lbs.toStringAsFixed(0)} lbs';
    }
  }

  String _formatHeight() {
    if (widget.data.heightCm == null) return '—';
    if (widget.data.isMetric) {
      return '${widget.data.heightCm!.toInt()} cm';
    } else {
      final totalInches = widget.data.heightCm! / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return "$feet'$inches\"";
    }
  }

  String _formatWaist() {
    if (widget.data.waistCm == null) return '—';
    if (widget.data.isMetric) {
      return '${widget.data.waistCm!.toInt()} cm';
    } else {
      final inches = widget.data.waistCm! / 2.54;
      return '${inches.toStringAsFixed(1)}"';
    }
  }

  Future<void> _selectWeight() async {
    final result = await WeightPickerSheet.show(
      context: context,
      initialWeight: widget.data.weightKg,
      initialUnit: widget.data.isMetric ? WeightUnit.kg : WeightUnit.lbs,
    );
    if (result != null && mounted) {
      widget.onDataChanged(widget.data.copyWith(weightKg: result.asKg));
    }
  }

  Future<void> _selectHeight() async {
    final result = await HeightPickerSheet.show(
      context: context,
      initialHeightCm: widget.data.heightCm,
      initialUnit: widget.data.isMetric ? HeightUnit.cm : HeightUnit.ftIn,
    );
    if (result != null && mounted) {
      widget.onDataChanged(widget.data.copyWith(heightCm: result.valueCm));
    }
  }

  Future<void> _selectWaist() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final result = await showModalBottomSheet<double?>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => _WaistPickerSheet(
        initialValue: widget.data.waistCm,
        isMetric: widget.data.isMetric,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );

    if (result != null && mounted) {
      widget.onDataChanged(widget.data.copyWith(waistCm: result));
    }
  }

  Future<void> _selectHealthConditions() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final result = await showModalBottomSheet<BodyHealthData?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => _HealthConditionsSheet(
        data: widget.data,
        isFemale: widget.isFemale,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );

    if (result != null && mounted) {
      widget.onDataChanged(result);
    }
  }

  String _formatConditions() {
    final conditions = widget.data.conditions
        .where((c) => c != HealthCondition.none)
        .map((c) => c.label)
        .toList();
    conditions.addAll(widget.data.customConditions);

    if (conditions.isEmpty) {
      return 'I\'m healthy';
    }
    if (conditions.length <= 2) {
      return conditions.join(', ');
    }
    return '${conditions.take(2).join(', ')} +${conditions.length - 2} more';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        _buildSectionHeader(colorScheme, textTheme),
        const SizedBox(height: AppSpacing.sm),

        // All body & health rows in a single card
        _buildBodyHealthCard(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildSectionHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxs),
      child: Text(
        'Body & Health',
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBodyHealthCard(ColorScheme colorScheme, TextTheme textTheme) {
    final hasConditions = !widget.data.hasNoConditions;
    final conditionsSummary = _formatConditions();

    return ProfileCard(
      child: Column(
        children: [
          // Unit System row at top for easy selection before entering values
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.straighten_outlined,
                  size: AppSpacing.iconSizeSmall,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Unit System',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                AppSegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(value: true, label: Text('Metric')),
                    ButtonSegment<bool>(value: false, label: Text('Imperial')),
                  ],
                  selected: {widget.data.isMetric},
                  onSelectionChanged: (selection) {
                    widget.onDataChanged(
                      widget.data.copyWith(isMetric: selection.first),
                    );
                  },
                ),
              ],
            ),
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: _formatWeight(),
            onTap: _selectWeight,
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: Icons.height_outlined,
            label: 'Height',
            value: _formatHeight(),
            onTap: _selectHeight,
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: Icons.straighten_outlined,
            label: 'Waist',
            value: _formatWaist(),
            onTap: _selectWaist,
          ),
          const ProfileRowDivider(),
          // Health Conditions row
          ProfileTappableRow(
            icon: Icons.medical_information_outlined,
            label: 'Health Conditions',
            value: hasConditions ? null : 'I\'m healthy',
            subtitle: hasConditions ? conditionsSummary : null,
            onTap: _selectHealthConditions,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for selecting health conditions
class _HealthConditionsSheet extends StatefulWidget {
  final BodyHealthData data;
  final bool isFemale;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _HealthConditionsSheet({
    required this.data,
    required this.isFemale,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<_HealthConditionsSheet> createState() => _HealthConditionsSheetState();
}

class _HealthConditionsSheetState extends State<_HealthConditionsSheet> {
  late Set<HealthCondition> _conditions;
  late List<String> _customConditions;
  bool _showInput = false;
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _conditions = Set.from(widget.data.conditions);
    _customConditions = List.from(widget.data.customConditions);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  bool get _hasAnyCondition =>
      _conditions.where((c) => c != HealthCondition.none).isNotEmpty ||
      _customConditions.isNotEmpty;

  void _toggleCondition(HealthCondition condition) {
    HapticFeedback.selectionClick();
    setState(() {
      if (condition == HealthCondition.none) {
        // Selecting "I'm healthy" clears all conditions
        _conditions.clear();
        _conditions.add(HealthCondition.none);
        _customConditions.clear();
        return;
      }

      _conditions.remove(HealthCondition.none);

      if (_conditions.contains(condition)) {
        _conditions.remove(condition);
        if (_conditions.isEmpty && _customConditions.isEmpty) {
          _conditions.add(HealthCondition.none);
        }
      } else {
        _conditions.add(condition);
      }
    });
  }

  void _removeCustomCondition(String condition) {
    HapticFeedback.selectionClick();
    setState(() {
      _customConditions.remove(condition);
      if (_conditions.isEmpty && _customConditions.isEmpty) {
        _conditions.add(HealthCondition.none);
      }
    });
  }

  void _submitInput() {
    final items = _inputController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .where(
          (s) =>
              !_customConditions.any((c) => c.toLowerCase() == s.toLowerCase()),
        )
        .toList();

    if (items.isNotEmpty) {
      setState(() {
        _conditions.remove(HealthCondition.none);
        _customConditions.addAll(items);
      });
    }

    _inputController.clear();
    setState(() => _showInput = false);
  }

  void _confirmSelection() {
    Navigator.pop(
      context,
      widget.data.copyWith(
        conditions: _conditions,
        customConditions: _customConditions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    final textTheme = widget.textTheme;

    // Filter conditions based on gender
    final availableConditions = HealthCondition.values
        .where((c) => c != HealthCondition.none)
        .where((c) => !c.isFemaleOnly || widget.isFemale)
        .toList();

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

            // Header with Done button
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
                          'Health Conditions',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Help us personalize your experience safely',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _confirmSelection,
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

            const SizedBox(height: AppSpacing.sm),

            // Chips wrap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  // "I'm healthy" chip
                  FilterChip(
                    label: Text(HealthCondition.none.label),
                    selected: !_hasAnyCondition,
                    onSelected: (_) => _toggleCondition(HealthCondition.none),
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.onPrimaryContainer,
                    side: BorderSide(
                      color: !_hasAnyCondition
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.buttonRadius,
                      ),
                    ),
                    labelStyle: textTheme.labelMedium?.copyWith(
                      color: !_hasAnyCondition
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: !_hasAnyCondition
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),

                  // Condition chips
                  ...availableConditions.map((condition) {
                    final isSelected = _conditions.contains(condition);
                    return FilterChip(
                      label: Text(condition.label),
                      selected: isSelected,
                      onSelected: (_) => _toggleCondition(condition),
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.onPrimaryContainer,
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.buttonRadius,
                        ),
                      ),
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    );
                  }),

                  // Custom conditions (deletable)
                  ..._customConditions.map((condition) {
                    return InputChip(
                      label: Text(condition),
                      onDeleted: () => _removeCustomCondition(condition),
                      backgroundColor: colorScheme.primaryContainer,
                      deleteIconColor: colorScheme.onPrimaryContainer,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.buttonRadius,
                        ),
                      ),
                    );
                  }),

                  // "+ Other" chip
                  if (!_showInput)
                    ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          const Text('Other'),
                        ],
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _showInput = true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _inputFocusNode.requestFocus();
                        });
                      },
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(color: colorScheme.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.buttonRadius,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Inline input for custom conditions
            AnimatedSize(
              duration: AppSpacing.durationFast,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: !_showInput
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.sm,
                        AppSpacing.xl,
                        0,
                      ),
                      child: TextField(
                        controller: _inputController,
                        focusNode: _inputFocusNode,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'e.g., IBS, Celiac, Arthritis',
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLow,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.inputRadius,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _inputController.clear();
                                  setState(() => _showInput = false);
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                onPressed: _submitInput,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),
                        onSubmitted: (_) => _submitInput(),
                      ),
                    ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

/// Waist picker sheet using Cupertino-style wheel picker
class _WaistPickerSheet extends StatefulWidget {
  final double? initialValue;
  final bool isMetric;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WaistPickerSheet({
    this.initialValue,
    required this.isMetric,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<_WaistPickerSheet> createState() => _WaistPickerSheetState();
}

class _WaistPickerSheetState extends State<_WaistPickerSheet> {
  late double _valueCm;
  late bool _isMetric;
  late FixedExtentScrollController _controller;

  // Waist ranges
  // Men: 65-130 cm (26-51 in), Women: 55-115 cm (22-45 in)
  // Using combined range to cover both
  static const _minCm = 50;
  static const _maxCm = 150;
  static const _minInch = 20;
  static const _maxInch = 59;

  @override
  void initState() {
    super.initState();
    _valueCm =
        widget.initialValue?.clamp(_minCm.toDouble(), _maxCm.toDouble()) ??
        80.0;
    _isMetric = widget.isMetric;
    _controller = FixedExtentScrollController(
      initialItem: _isMetric
          ? _valueCm.toInt() - _minCm
          : (_valueCm / 2.54).round() - _minInch,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _displayValue {
    if (_isMetric) return _valueCm.toInt();
    return (_valueCm / 2.54).round();
  }

  String get _unitLabel => _isMetric ? 'cm' : 'in';

  void _toggleUnit() {
    setState(() {
      _isMetric = !_isMetric;
    });

    // Jump after frame renders (controller needs to be attached)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isMetric) {
        _controller.jumpToItem(_valueCm.toInt() - _minCm);
      } else {
        _controller.jumpToItem((_valueCm / 2.54).round() - _minInch);
      }
    });
  }

  void _onValueChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isMetric) {
        _valueCm = (index + _minCm).toDouble();
      } else {
        _valueCm = (index + _minInch) * 2.54;
      }
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, _valueCm);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final itemCount = _isMetric ? _maxCm - _minCm + 1 : _maxInch - _minInch + 1;
    final minVal = _isMetric ? _minCm : _minInch;

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

            // Header with Done button
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
                          'Waist',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Scroll to set your waist size',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _confirmSelection,
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

            // Instruction tip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Measure at belly button level, breathing out naturally',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Large value display
            Text(
              '$_displayValue $_unitLabel',
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                height: 1,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Unit toggle
            WheelUnitToggle(
              options: const ['cm', 'in'],
              selectedIndex: _isMetric ? 0 : 1,
              onChanged: (_) => _toggleUnit(),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Wheel picker
            SizedBox(
              height: WheelConstants.defaultHeight,
              child: Stack(
                children: [
                  // Value wheel
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: WheelConstants.itemExtent,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: WheelConstants.diameterRatio,
                    perspective: WheelConstants.perspective,
                    onSelectedItemChanged: _onValueChanged,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: itemCount,
                      builder: (context, index) {
                        final value = index + minVal;
                        final isSelected = value == _displayValue;
                        return Center(
                          child: Text(
                            '$value',
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
                  const WheelGradientOverlay(),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
