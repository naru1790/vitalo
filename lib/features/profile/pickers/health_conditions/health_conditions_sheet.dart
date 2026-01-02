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

  bool _isAddingCustom = false;

  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();

    _conditions = Set<HealthCondition>.from(widget.initialData.conditions);
    _customConditions = List<String>.from(widget.initialData.customConditions);
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool get _hasAnyCondition =>
      _conditions.isNotEmpty || _customConditions.isNotEmpty;

  bool get _canAddCustom {
    return _parseCustomInput(_customController.text).isNotEmpty;
  }

  void _selectHealthy() {
    setState(() {
      _conditions.clear();
      _customConditions.clear();
    });
  }

  void _toggleCondition(HealthCondition condition) {
    setState(() {
      if (_conditions.contains(condition)) {
        _conditions.remove(condition);
      } else {
        _conditions.add(condition);
      }
    });
  }

  void _removeCustomCondition(String condition) {
    setState(() {
      _customConditions.remove(condition);
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

  void _enterCustomEditMode() {
    setState(() {
      _isAddingCustom = true;
    });
  }

  void _addCustomAndExit() {
    final items = _parseCustomInput(_customController.text);
    if (items.isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _customConditions = [..._customConditions, ...items];
      _customController.clear();
      _isAddingCustom = false;
    });
  }

  void _confirmSelection() {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isAddingCustom = false;
    });

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

    final isCompactHeader = _isAddingCustom;

    final header = <Widget>[
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
      if (!isCompactHeader) ...[
        SizedBox(height: spacing.xs),
        const AppText(
          'Help us personalize your experience safely',
          variant: AppTextVariant.caption,
          color: AppTextColor.secondary,
          align: TextAlign.center,
        ),
      ],
      SizedBox(height: isCompactHeader ? spacing.md : spacing.lg),
    ];

    final conditionsSurface = AppSurface(
      variant: AppSurfaceVariant.card,
      child: AppSurfaceBody(
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: [
            // Semantics: reset action (button) that clears all selections.
            Semantics(
              button: true,
              label: "I'm healthy",
              onTapHint: 'Clears all selected conditions',
              onTap: _selectHealthy,
              child: ExcludeSemantics(
                child: AppChoiceChip(
                  label: "I'm healthy",
                  selected: !_hasAnyCondition,
                  onSelected: _selectHealthy,
                ),
              ),
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
    );

    final readOnlyCustomSurface = _customConditions.isEmpty
        ? null
        : AppSurface(
            variant: AppSurfaceVariant.card,
            child: AppSurfaceBody(
              child: Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final condition in _customConditions)
                    // Read-only informational pill (must announce as text).
                    Semantics(
                      label: condition,
                      container: true,
                      child: ExcludeSemantics(
                        child: AppChoiceChip(
                          label: condition,
                          selected: true,
                          onSelected: null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );

    final customEditSurface = AppSurface(
      variant: AppSurfaceVariant.card,
      child: AppSurfaceBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _customController,
              placeholder: 'e.g., IBS, Celiac, Arthritis',
              textInputAction: TextInputAction.done,
              onSubmitted: _addCustomAndExit,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: spacing.sm),
            AppButton(
              label: 'Add',
              variant: AppButtonVariant.secondary,
              enabled: _canAddCustom,
              onPressed: _addCustomAndExit,
              leadingIcon: icons.AppIcon.actionConfirm,
            ),
            if (_customConditions.isNotEmpty) ...[
              SizedBox(height: spacing.lg),
              Wrap(
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
            ],
          ],
        ),
      ),
    );

    if (!_isAddingCustom) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...header,
          conditionsSurface,
          if (readOnlyCustomSurface != null) ...[
            SizedBox(height: spacing.lg),
            readOnlyCustomSurface,
          ],
          SizedBox(height: spacing.lg),
          AppButton(
            label: 'Other',
            variant: AppButtonVariant.secondary,
            onPressed: _enterCustomEditMode,
            leadingIcon: icons.AppIcon.actionAdd,
          ),
          SizedBox(height: spacing.lg),
          AppButton(
            label: 'Done',
            variant: AppButtonVariant.primary,
            onPressed: _confirmSelection,
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...header,
        conditionsSurface,
        SizedBox(height: spacing.lg),
        customEditSurface,
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
