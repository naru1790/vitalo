// =============================================================================
// COACHING SECTION - Goals & Coach Personality
// =============================================================================
// User's health goal and preferred AI coaching style.
// iOS 26 Liquid Glass design - CupertinoIcons, Cupertino controls.
// =============================================================================

import 'package:flutter/cupertino.dart';
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
    CupertinoIcons.arrow_down_right,
    GoalColors.loseWeight,
  ),
  buildMuscle(
    'Build Muscle',
    'Get stronger and more toned',
    CupertinoIcons.flame,
    GoalColors.buildMuscle,
  ),
  improveSleep(
    'Improve Sleep',
    'Better rest and recovery',
    CupertinoIcons.moon_fill,
    GoalColors.improveSleep,
  ),
  manageStress(
    'Manage Stress',
    'Find calm and mental clarity',
    CupertinoIcons.leaf_arrow_circlepath,
    GoalColors.manageStress,
  ),
  boostStamina(
    'Boost Stamina',
    'Increase energy and endurance',
    CupertinoIcons.bolt_fill,
    GoalColors.boostStamina,
  ),
  maintainWeight(
    'Maintain Weight',
    'Stay consistent and balanced',
    CupertinoIcons.equal,
    GoalColors.maintainWeight,
  ),
  gainWeight(
    'Gain Weight',
    'Build mass in a healthy way',
    CupertinoIcons.arrow_up_right,
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
    CupertinoIcons.hand_thumbsup_fill,
    CoachColors.supportiveFriend,
  ),
  toughCoach(
    'Tough Coach',
    'Direct, no excuses, accountability-focused',
    '"No shortcuts. Show up and do the work."',
    CupertinoIcons.sportscourt,
    CoachColors.toughCoach,
  ),
  calmMentor(
    'Calm Mentor',
    'Patient, wise, sustainable habits focus',
    '"Progress takes time. Trust the process."',
    CupertinoIcons.person_fill,
    CoachColors.calmMentor,
  ),
  energeticHype(
    'Energetic Hype',
    'High energy, enthusiastic, motivating',
    '"LET\'S GO! Today is YOUR day! 🔥"',
    CupertinoIcons.flame_fill,
    CoachColors.energeticHype,
  ),
  dataAnalyst(
    'Data Analyst',
    'Logical, evidence-based, loves metrics',
    '"Your data shows 12% improvement."',
    CupertinoIcons.chart_bar_fill,
    CoachColors.dataAnalyst,
  ),
  mindfulGuide(
    'Mindful Guide',
    'Holistic, balanced, wellness-focused',
    '"Listen to your body. Rest is growth."',
    CupertinoIcons.leaf_arrow_circlepath,
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
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xxs),
          child: Text(
            'Your Coach',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // All coaching rows in a single card
        ProfileCard(
          child: Column(
            children: [
              ProfileTappableRow(
                icon: CupertinoIcons.flag_fill,
                label: 'My Goal',
                value: data.goal?.label ?? '—',
                onTap: () => _selectGoal(context),
              ),
              const ProfileRowDivider(),
              ProfileTappableRow(
                icon: CupertinoIcons.person_fill,
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
    return showCupertinoModalPopup<HealthGoal>(
      context: context,
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
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
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
                  color: separatorColor,
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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Choose your primary health focus',
                          style: TextStyle(fontSize: 15, color: secondaryLabel),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    onPressed: _selected != null ? _confirm : null,
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final goalColor = goal.color;

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
                color: goalColor.withValues(alpha: isSelected ? 1.0 : 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
              ),
              child: Icon(
                goal.icon,
                color: isSelected ? CupertinoColors.white : goalColor,
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal.description,
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
// COACHING STYLE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _CoachingStyleSheet extends StatefulWidget {
  final CoachingStyle? initialValue;

  const _CoachingStyleSheet({this.initialValue});

  static Future<CoachingStyle?> show({
    required BuildContext context,
    CoachingStyle? initialValue,
  }) {
    return showCupertinoModalPopup<CoachingStyle>(
      context: context,
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
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
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
                  color: separatorColor,
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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'How would you like to be coached?',
                          style: TextStyle(fontSize: 15, color: secondaryLabel),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    onPressed: _selected != null ? _confirm : null,
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final coachColor = style.color;

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
                color: isSelected ? CupertinoColors.white : coachColor,
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    style.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.8)
                          : secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Sample quote
                  Text(
                    style.sampleQuote,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.7)
                          : secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: primaryColor,
                  size: AppSpacing.iconSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
