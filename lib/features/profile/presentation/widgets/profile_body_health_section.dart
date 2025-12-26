import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/wheel_picker.dart';
import '../../../../design/design.dart';
import '../../../../design/tokens/icons.dart' as icons;

/// Feature widget for the Profile → Body & Health section content.
///
/// Mirrors the usage pattern of [ProfilePersonalInfoSection]: the parent page owns
/// the semantic section boundary (via [AppSection]) and passes semantic labels
/// + intent callbacks down.
class ProfileBodyHealthSection extends StatelessWidget {
  const ProfileBodyHealthSection({
    super.key,
    required this.heightLabel,
    required this.weightLabel,
    required this.waistLabel,
    required this.unitSystem,
    required this.healthConditionsValue,
    required this.healthConditionsSubtitle,
    required this.onHeightTap,
    required this.onWeightTap,
    required this.onWaistTap,
    required this.onUnitSystemChanged,
    required this.onHealthConditionsTap,
    this.onBodyHealthEditTap,
  });

  final String heightLabel;
  final String weightLabel;
  final String waistLabel;
  final AppUnitSystem unitSystem;

  /// When the user has no conditions, this should usually be "I'm healthy".
  /// When the user has conditions, this should typically be null and the
  /// summary should be provided via [healthConditionsSubtitle].
  final String? healthConditionsValue;

  /// Summary of conditions, shown only when the user has selected issues.
  final String? healthConditionsSubtitle;

  final VoidCallback onHeightTap;
  final VoidCallback onWeightTap;
  final VoidCallback onWaistTap;
  final ValueChanged<AppUnitSystem> onUnitSystemChanged;
  final VoidCallback onHealthConditionsTap;

  /// Optional "edit" affordance if the hub needs a single entrypoint.
  ///
  /// Keep unused by default to avoid changing the visible UI.
  final VoidCallback? onBodyHealthEditTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.card,
      child: Column(
        children: [
          AppUnitSystemSelector(
            value: unitSystem,
            onChanged: onUnitSystemChanged,
            label: Row(
              children: [
                const AppIcon(
                  icons.AppIcon.systemUnits,
                  size: AppIconSize.small,
                  color: AppIconColor.brand,
                ),
                SizedBox(width: Spacing.of.md),
                const AppText(
                  'Unit System',
                  variant: AppTextVariant.body,
                  color: AppTextColor.primary,
                ),
              ],
            ),
            metricLabel: 'Metric',
            imperialLabel: 'Imperial',
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthWeight,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Weight',
            value: weightLabel,
            showsChevron: true,
            onTap: onWeightTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthHeight,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Height',
            value: heightLabel,
            showsChevron: true,
            onTap: onHeightTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthWaist,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Waist',
            value: waistLabel,
            showsChevron: true,
            onTap: onWaistTap,
          ),

          const AppDivider(inset: AppDividerInset.leading),

          AppListTile(
            leading: const AppIcon(
              icons.AppIcon.healthConditions,
              size: AppIconSize.small,
              color: AppIconColor.brand,
            ),
            title: 'Health Conditions',
            value: healthConditionsValue,
            subtitle: healthConditionsSubtitle,
            showsChevron: true,
            onTap: onHealthConditionsTap,
          ),

          if (onBodyHealthEditTap != null) ...[
            const AppDivider(inset: AppDividerInset.leading),
            AppListTile(
              title: 'Edit Body & Health',
              showsChevron: true,
              onTap: onBodyHealthEditTap,
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Models + flows (single source of truth)
// ───────────────────────────────────────────────────────────────────────────

/// Navigation entrypoints for Body & Health editing flows.
///
/// These preserve the existing native sheets while allowing hub pages to remain
/// summary-only (tap → navigate → return result).
abstract final class BodyHealthFlows {
  BodyHealthFlows._();

  static Future<double?> selectWaist({
    required BuildContext context,
    required bool isMetric,
    double? initialValueCm,
  }) {
    return showCupertinoModalPopup<double?>(
      context: context,
      builder: (context) =>
          _WaistPickerSheet(initialValue: initialValueCm, isMetric: isMetric),
    );
  }

  static Future<BodyHealthData?> selectHealthConditions({
    required BuildContext context,
    required BodyHealthData data,
    required AppGender gender,
  }) {
    return showCupertinoModalPopup<BodyHealthData?>(
      context: context,
      builder: (context) => _HealthConditionsSheet(data: data, gender: gender),
    );
  }
}

/// Predefined health conditions with simple, user-friendly labels.
///
/// Focus on conditions that significantly impact diet/nutrition recommendations.
enum HealthCondition {
  none('I\'m healthy', null),
  // Metabolic conditions
  diabetes('Diabetes (Type 2)', CupertinoIcons.drop),
  preDiabetes('Pre-diabetic', CupertinoIcons.drop),
  highBP('High Blood Pressure', CupertinoIcons.heart),
  cholesterol('High Cholesterol', CupertinoIcons.chart_bar),
  // Hormonal conditions
  thyroid('Thyroid Issues', CupertinoIcons.waveform_path_ecg),
  pcos('PCOS', CupertinoIcons.person),
  // Kidney & Liver
  kidneyDisease('Kidney Disease', CupertinoIcons.drop_fill),
  fattyLiver('Fatty Liver', CupertinoIcons.bandage),
  // Heart
  heartDisease('Heart Disease', CupertinoIcons.heart_fill),
  // Female-specific conditions
  pregnant('Pregnant', CupertinoIcons.person_2),
  lactating('Breastfeeding', CupertinoIcons.person_2_fill);

  const HealthCondition(this.label, this.icon);
  final String label;
  final IconData? icon;

  bool get isFemaleOnly => this == pregnant || this == lactating;
}

extension HealthConditionAvailability on HealthCondition {
  /// Lists health conditions available for the given gender.
  ///
  /// Domain rules live here; sheets must not infer availability.
  static List<HealthCondition> availableFor(AppGender gender) {
    return HealthCondition.values
        .where((c) => c != HealthCondition.none)
        .where((c) => !c.isFemaleOnly || gender == AppGender.female)
        .toList(growable: false);
  }
}

class BodyHealthData {
  const BodyHealthData({
    this.weightKg,
    this.heightCm,
    this.waistCm,
    this.conditions = const {},
    this.customConditions = const [],
  });

  final double? weightKg;
  final double? heightCm;
  final double? waistCm;
  final Set<HealthCondition> conditions;
  final List<String> customConditions;

  BodyHealthData copyWith({
    double? weightKg,
    double? heightCm,
    double? waistCm,
    Set<HealthCondition>? conditions,
    List<String>? customConditions,
  }) {
    return BodyHealthData(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
      conditions: conditions ?? this.conditions,
      customConditions: customConditions ?? this.customConditions,
    );
  }

  bool get hasNoConditions =>
      conditions.isEmpty ||
      (conditions.length == 1 && conditions.contains(HealthCondition.none));
}

extension BodyHealthConditionsDisplay on BodyHealthData {
  String get conditionsSummary {
    final items = conditions
        .where((c) => c != HealthCondition.none)
        .map((c) => c.label)
        .toList();
    items.addAll(customConditions);

    if (items.isEmpty) {
      return 'I\'m healthy';
    }
    if (items.length <= 2) {
      return items.join(', ');
    }
    return '${items.take(2).join(', ')} +${items.length - 2} more';
  }
}

extension BodyHealthDisplay on BodyHealthData {
  String weightLabel(AppUnitSystem unitSystem) {
    if (weightKg == null) return '—';
    if (unitSystem == AppUnitSystem.metric) {
      return '${weightKg!.toStringAsFixed(1)} kg';
    }
    final lbs = weightKg! * 2.20462;
    return '${lbs.toStringAsFixed(0)} lbs';
  }

  String heightLabel(AppUnitSystem unitSystem) {
    if (heightCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${heightCm!.toInt()} cm';
    final totalInches = heightCm! / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  String waistLabel(AppUnitSystem unitSystem) {
    if (waistCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${waistCm!.toInt()} cm';
    final inches = waistCm! / 2.54;
    return '${inches.toStringAsFixed(1)}"';
  }
}

class _HealthConditionsSheet extends StatefulWidget {
  const _HealthConditionsSheet({required this.data, required this.gender});

  final BodyHealthData data;
  final AppGender gender;

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
        _conditions
          ..clear()
          ..add(HealthCondition.none);
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    final availableConditions = HealthConditionAvailability.availableFor(
      widget.gender,
    );

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: CupertinoColors.separator.resolveFrom(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Help us personalize your experience safely',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.secondaryLabel.resolveFrom(
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    onPressed: _confirmSelection,
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _buildIOSChip(
                    context: context,
                    label: HealthCondition.none.label,
                    isSelected: !_hasAnyCondition,
                    onTap: () => _toggleCondition(HealthCondition.none),
                    primaryColor: primaryColor,
                  ),

                  ...availableConditions.map((condition) {
                    final isSelected = _conditions.contains(condition);
                    return _buildIOSChip(
                      context: context,
                      label: condition.label,
                      isSelected: isSelected,
                      onTap: () => _toggleCondition(condition),
                      primaryColor: primaryColor,
                    );
                  }),

                  ..._customConditions.map((condition) {
                    return _buildIOSDeletableChip(
                      context: context,
                      label: condition,
                      onDelete: () => _removeCustomCondition(condition),
                      primaryColor: primaryColor,
                    );
                  }),

                  if (!_showInput)
                    _buildIOSActionChip(
                      context: context,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _showInput = true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _inputFocusNode.requestFocus();
                        });
                      },
                    ),
                ],
              ),
            ),

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
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField(
                              controller: _inputController,
                              focusNode: _inputFocusNode,
                              textCapitalization: TextCapitalization.words,
                              placeholder: 'e.g., IBS, Celiac, Arthritis',
                              placeholderStyle: TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.secondaryLabel
                                    .resolveFrom(context),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.tertiarySystemFill
                                    .resolveFrom(context),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.inputRadius,
                                ),
                              ),
                              onSubmitted: (_) => _submitInput(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _inputController.clear();
                              setState(() => _showInput = false);
                            },
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: CupertinoColors.secondaryLabel.resolveFrom(
                                context,
                              ),
                              size: 24,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _submitInput,
                            child: Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.15)
              : CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : CupertinoColors.separator.resolveFrom(context),
            width: LiquidGlass.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(CupertinoIcons.checkmark, size: 14, color: primaryColor),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? CupertinoColors.label.resolveFrom(context)
                    : CupertinoColors.secondaryLabel.resolveFrom(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOSDeletableChip({
    required BuildContext context,
    required String label,
    required VoidCallback onDelete,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.xs,
        top: AppSpacing.xxs,
        bottom: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: primaryColor, width: LiquidGlass.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.label.resolveFrom(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              size: 18,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIOSActionChip({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: LiquidGlass.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.add,
              size: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              'Other',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Waist picker sheet using Cupertino-style wheel picker.
class _WaistPickerSheet extends StatefulWidget {
  const _WaistPickerSheet({this.initialValue, required this.isMetric});

  final double? initialValue;
  final bool isMetric;

  @override
  State<_WaistPickerSheet> createState() => _WaistPickerSheetState();
}

class _WaistPickerSheetState extends State<_WaistPickerSheet> {
  late double _valueCm;
  late bool _isMetric;
  late FixedExtentScrollController _controller;

  static const _minCm = 50;
  static const _maxCm = 200;
  static const _minInch = 20;
  static const _maxInch = 79;

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
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    final itemCount = _isMetric ? _maxCm - _minCm + 1 : _maxInch - _minInch + 1;
    final minVal = _isMetric ? _minCm : _minInch;

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: CupertinoColors.separator.resolveFrom(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Scroll to set your waist size',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.secondaryLabel.resolveFrom(
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    onPressed: _confirmSelection,
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.lightbulb,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Measure at belly button level, breathing out naturally',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              '$_displayValue $_unitLabel',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w600,
                color: primaryColor,
                height: 1,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            WheelUnitToggle(
              options: const ['cm', 'in'],
              selectedIndex: _isMetric ? 0 : 1,
              onChanged: (_) => _toggleUnit(),
            ),

            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              height: WheelConstants.defaultHeight,
              child: Stack(
                children: [
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: WheelConstants.itemExtent,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: WheelConstants.diameterRatio,
                    perspective: WheelConstants.perspective,
                    onSelectedItemChanged: _onValueChanged,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: itemCount,
                      builder: (ctx, index) {
                        final value = index + minVal;
                        final isSelected = value == _displayValue;
                        return Center(
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 28,
                              color: isSelected
                                  ? primaryColor
                                  : CupertinoColors.secondaryLabel.resolveFrom(
                                      context,
                                    ),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

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
