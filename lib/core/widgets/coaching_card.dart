// =============================================================================
// COACHING SECTION - Goals & Coach Personality
// =============================================================================
// User's health goal and preferred AI coaching style.
// Follows soft minimalist design language.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'profile_row.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HEALTH GOALS - Ordered by popularity
// ─────────────────────────────────────────────────────────────────────────────

/// User's primary health goal/motivation
enum HealthGoal {
  loseWeight(
    'Lose Weight',
    'Shed extra pounds and feel lighter',
    Icons.trending_down_rounded,
    GoalColors.loseWeight,
  ),
  buildMuscle(
    'Build Muscle',
    'Get stronger and more toned',
    Icons.fitness_center_rounded,
    GoalColors.buildMuscle,
  ),
  improveSleep(
    'Improve Sleep',
    'Better rest and recovery',
    Icons.bedtime_rounded,
    GoalColors.improveSleep,
  ),
  manageStress(
    'Manage Stress',
    'Find calm and mental clarity',
    Icons.self_improvement_rounded,
    GoalColors.manageStress,
  ),
  boostStamina(
    'Boost Stamina',
    'Increase energy and endurance',
    Icons.bolt_rounded,
    GoalColors.boostStamina,
  ),
  maintainWeight(
    'Maintain Weight',
    'Stay consistent and balanced',
    Icons.balance_rounded,
    GoalColors.maintainWeight,
  ),
  gainWeight(
    'Gain Weight',
    'Build mass in a healthy way',
    Icons.trending_up_rounded,
    GoalColors.gainWeight,
  );

  const HealthGoal(this.label, this.description, this.icon, this.color);

  final String label;
  final String description;
  final IconData icon;
  final Color color;
}

// ─────────────────────────────────────────────────────────────────────────────
// COACHING STYLES - AI personality preferences
// ─────────────────────────────────────────────────────────────────────────────

/// AI coach personality/communication style
enum CoachingStyle {
  supportiveFriend(
    'Supportive Friend',
    'Warm, encouraging, celebrates small wins',
    '"You\'ve got this! Every step counts 💪"',
    Icons.volunteer_activism_rounded,
    CoachColors.supportiveFriend,
  ),
  toughCoach(
    'Tough Coach',
    'Direct, no excuses, accountability-focused',
    '"No shortcuts. Show up and do the work."',
    Icons.fitness_center_rounded,
    CoachColors.toughCoach,
  ),
  calmMentor(
    'Calm Mentor',
    'Patient, wise, sustainable habits focus',
    '"Progress takes time. Trust the process."',
    Icons.psychology_rounded,
    CoachColors.calmMentor,
  ),
  energeticHype(
    'Energetic Hype',
    'High energy, enthusiastic, motivating',
    '"LET\'S GO! Today is YOUR day! 🔥"',
    Icons.local_fire_department_rounded,
    CoachColors.energeticHype,
  ),
  dataAnalyst(
    'Data Analyst',
    'Logical, evidence-based, loves metrics',
    '"Your data shows 12% improvement."',
    Icons.insights_rounded,
    CoachColors.dataAnalyst,
  ),
  mindfulGuide(
    'Mindful Guide',
    'Holistic, balanced, wellness-focused',
    '"Listen to your body. Rest is growth."',
    Icons.self_improvement_rounded,
    CoachColors.mindfulGuide,
  );

  const CoachingStyle(
    this.label,
    this.description,
    this.sampleQuote,
    this.icon,
    this.color,
  );

  final String label;
  final String description;
  final String sampleQuote;
  final IconData icon;
  final Color color;
}

// ─────────────────────────────────────────────────────────────────────────────
// COACHING DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

/// Result from coaching card selections
class CoachingData {
  const CoachingData({this.goal, this.coachingStyle});

  final HealthGoal? goal;
  final CoachingStyle? coachingStyle;

  CoachingData copyWith({HealthGoal? goal, CoachingStyle? coachingStyle}) {
    return CoachingData(
      goal: goal ?? this.goal,
      coachingStyle: coachingStyle ?? this.coachingStyle,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COACHING CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Coaching section with goal and coach personality selection
class CoachingCard extends StatelessWidget {
  const CoachingCard({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  final CoachingData data;
  final ValueChanged<CoachingData> onDataChanged;

  Future<void> _selectGoal(BuildContext context) async {
    final result = await _HealthGoalSheet.show(
      context: context,
      initialValue: data.goal,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(goal: result));
    }
  }

  Future<void> _selectCoachingStyle(BuildContext context) async {
    final result = await _CoachingStyleSheet.show(
      context: context,
      initialValue: data.coachingStyle,
    );
    if (result != null && context.mounted) {
      onDataChanged(data.copyWith(coachingStyle: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xxs),
          child: Text(
            'Your Coach',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // All coaching rows in a single card
        ProfileCard(
          child: Column(
            children: [
              ProfileTappableRow(
                icon: Icons.flag_rounded,
                label: 'My Goal',
                value: data.goal?.label ?? '—',
                onTap: () => _selectGoal(context),
              ),
              const ProfileRowDivider(),
              ProfileTappableRow(
                icon: Icons.person_rounded,
                label: 'Coaching Style',
                value: data.coachingStyle?.label ?? '—',
                onTap: () => _selectCoachingStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEALTH GOAL SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _HealthGoalSheet extends StatefulWidget {
  final HealthGoal? initialValue;

  const _HealthGoalSheet({this.initialValue});

  static Future<HealthGoal?> show({
    required BuildContext context,
    HealthGoal? initialValue,
  }) {
    return showModalBottomSheet<HealthGoal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => _HealthGoalSheet(initialValue: initialValue),
    );
  }

  @override
  State<_HealthGoalSheet> createState() => _HealthGoalSheetState();
}

class _HealthGoalSheetState extends State<_HealthGoalSheet> {
  HealthGoal? _selected;

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
                          'What\'s Your Goal?',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Choose your primary health focus',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _selected != null ? _confirm : null,
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

            // Selected goal display
            if (_selected != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Text(
                  _selected!.label,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // Goal options as cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: HealthGoal.values.map((goal) {
                  final isSelected = _selected == goal;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _GoalCard(
                      goal: goal,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = goal);
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
    );
  }
}

class _GoalCard extends StatelessWidget {
  final HealthGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final goalColor = goal.color;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: goalColor.withValues(alpha: isSelected ? 1.0 : 0.15),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardRadiusSmall,
                  ),
                ),
                child: Icon(
                  goal.icon,
                  color: isSelected ? Colors.white : goalColor,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.label,
                      style: textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      goal.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: AppSpacing.iconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COACHING STYLE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _CoachingStyleSheet extends StatefulWidget {
  final CoachingStyle? initialValue;

  const _CoachingStyleSheet({this.initialValue});

  static Future<CoachingStyle?> show({
    required BuildContext context,
    CoachingStyle? initialValue,
  }) {
    return showModalBottomSheet<CoachingStyle>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => _CoachingStyleSheet(initialValue: initialValue),
    );
  }

  @override
  State<_CoachingStyleSheet> createState() => _CoachingStyleSheetState();
}

class _CoachingStyleSheetState extends State<_CoachingStyleSheet> {
  CoachingStyle? _selected;

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
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
                          'Choose Your Coach',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'How would you like to be coached?',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _selected != null ? _confirm : null,
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

            // Selected style display
            if (_selected != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Text(
                  _selected!.label,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // Coaching style options - scrollable
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    ...CoachingStyle.values.map((style) {
                      final isSelected = _selected == style;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _CoachingStyleCard(
                          style: style,
                          isSelected: isSelected,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selected = style);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachingStyleCard extends StatelessWidget {
  final CoachingStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoachingStyleCard({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final coachColor = style.color;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar with coaching style icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: coachColor.withValues(alpha: isSelected ? 1.0 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  style.icon,
                  color: isSelected ? Colors.white : coachColor,
                  size: AppSpacing.iconSizeLarge,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.label,
                      style: textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      style.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Sample quote
                    Text(
                      style.sampleQuote,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.8,
                              )
                            : colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                    size: AppSpacing.iconSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
