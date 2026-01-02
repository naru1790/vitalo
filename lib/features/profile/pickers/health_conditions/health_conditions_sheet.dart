import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';
import '../../models/body_health_data.dart';
import '../../../../design/tokens/icons.dart' as icons;

// @frozen
// Sheet: Body & Health → Health Conditions
// Owns: local selection + custom input UI state
// Emits: updated BodyHealthData via Navigator.pop
// Must NOT: present other modals, access services/repositories, show feedback UI
// Must NOT: apply sheet layout/styling (SheetPage owns structure)

/// Body & Health → Health conditions selection sheet.
///
/// Pure sheet content — must be wrapped by [SheetPage] in flows.
class HealthConditionsSheet extends StatefulWidget {
  const HealthConditionsSheet({
    super.key,
    required this.initialData,
    required this.gender,
  });

  final BodyHealthData initialData;
  final AppGender gender;

  @override
  State<HealthConditionsSheet> createState() => _HealthConditionsSheetState();
}

class _HealthConditionsSheetState extends State<HealthConditionsSheet> {
  late Set<HealthCondition> _conditions;
  late List<String> _customConditions;

  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();

    _conditions = Set<HealthCondition>.from(widget.initialData.conditions);
    _customConditions = List<String>.from(widget.initialData.customConditions);
    _customController = TextEditingController();

    _normalizeDraft();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool get _hasAnyCondition =>
      _conditions.where((c) => c != HealthCondition.none).isNotEmpty ||
      _customConditions.isNotEmpty;

  bool get _canAddCustom {
    return _parseCustomInput(_customController.text).isNotEmpty;
  }

  void _normalizeDraft() {
    // Invariant:
    // - "Healthy" is represented by either an empty selection OR {none}
    // - If any real condition/custom exists, "none" must be absent.
    final hasReal =
        _conditions.where((c) => c != HealthCondition.none).isNotEmpty ||
        _customConditions.isNotEmpty;

    if (hasReal) {
      _conditions.remove(HealthCondition.none);
      return;
    }

    if (_conditions.isEmpty) {
      _conditions = {HealthCondition.none};
    } else if (_conditions.length > 1) {
      _conditions.remove(HealthCondition.none);
      if (_conditions.isEmpty) {
        _conditions = {HealthCondition.none};
      }
    }
  }

  void _toggleCondition(HealthCondition condition) {
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
      } else {
        _conditions.add(condition);
      }

      _normalizeDraft();
    });
  }

  void _removeCustomCondition(String condition) {
    setState(() {
      _customConditions.remove(condition);
      _normalizeDraft();
    });
  }

  List<String> _parseCustomInput(String raw) {
    final items = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);

    if (items.isEmpty) return const [];

    final existingLower = _customConditions.map((c) => c.toLowerCase()).toSet();

    return items
        .where((s) => !existingLower.contains(s.toLowerCase()))
        .toList(growable: false);
  }

  void _addCustomConditions() {
    final items = _parseCustomInput(_customController.text);
    if (items.isEmpty) return;

    setState(() {
      _conditions.remove(HealthCondition.none);
      _customConditions = [..._customConditions, ...items];
      _customController.clear();
      _normalizeDraft();
    });
  }

  void _confirmSelection() {
    Navigator.pop(
      context,
      widget.initialData.copyWith(
        conditions: _conditions,
        customConditions: _customConditions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    final availableConditions = HealthConditionAvailability.availableFor(
      widget.gender,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Health Conditions',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        const AppText(
          'Help us personalize your experience safely',
          variant: AppTextVariant.caption,
          color: AppTextColor.secondary,
          align: TextAlign.center,
        ),
        SizedBox(height: spacing.lg),

        AppSurface(
          variant: AppSurfaceVariant.card,
          child: AppSurfaceBody(
            child: Wrap(
              spacing: spacing.sm,
              runSpacing: spacing.sm,
              children: [
                AppChoiceChip(
                  label: HealthCondition.none.label,
                  selected: !_hasAnyCondition,
                  onSelected: () => _toggleCondition(HealthCondition.none),
                ),
                for (final condition in availableConditions)
                  AppChoiceChip(
                    label: condition.label,
                    selected: _conditions.contains(condition),
                    onSelected: () => _toggleCondition(condition),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: spacing.lg),

        const AppText(
          'Other (comma-separated)',
          variant: AppTextVariant.label,
          color: AppTextColor.secondary,
        ),
        SizedBox(height: spacing.xs),
        AppTextField(
          controller: _customController,
          placeholder: 'e.g., IBS, Celiac, Arthritis',
          textInputAction: TextInputAction.done,
          onSubmitted: _addCustomConditions,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: spacing.sm),
        AppButton(
          label: 'Add',
          variant: AppButtonVariant.secondary,
          enabled: _canAddCustom,
          onPressed: _addCustomConditions,
          leadingIcon: icons.AppIcon.actionAdd,
        ),

        if (_customConditions.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          AppSurface(
            variant: AppSurfaceVariant.card,
            child: AppSurfaceBody(
              child: Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final condition in _customConditions)
                    AppEditablePill(
                      label: condition,
                      onRemove: () => _removeCustomCondition(condition),
                    ),
                ],
              ),
            ),
          ),
        ],

        SizedBox(height: spacing.lg),

        AppButton(
          label: 'Done',
          variant: AppButtonVariant.primary,
          onPressed: _confirmSelection,
        ),
      ],
    );
  }
}
