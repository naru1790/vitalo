import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
// DIETARY PREFERENCES - Smart Diet Funnel
// Progressive disclosure based on base identity selection
// ═══════════════════════════════════════════════════════════════════════════

/// Base dietary identity that filters subsequent options
enum DietIdentity {
  vegan(
    'Vegan',
    'Plant-based diet, no dairy or meat',
    Icons.eco_rounded,
    DietColors.vegan,
  ),
  vegetarian(
    'Vegetarian',
    'No meat or fish, dairy is fine',
    Icons.spa_rounded,
    DietColors.vegetarian,
  ),
  eggetarian(
    'Eggetarian',
    'Vegetarian diet that includes eggs',
    Icons.egg_rounded,
    DietColors.eggetarian,
  ),
  omnivore(
    'Omnivore',
    'Flexible diet, eats all food types',
    Icons.restaurant_rounded,
    DietColors.omnivore,
  );

  const DietIdentity(this.label, this.description, this.icon, this.color);
  final String label;
  final String description;
  final IconData icon;
  final Color color;
}

/// Diet goal/mode
enum DietGoal {
  balanced('Balanced', 'Wholesome nutrition'),
  keto('Keto', 'Low carb, high fat'),
  paleo('Paleo', 'Whole foods focus'),
  lowCarb('Low Carb', 'Fewer carbohydrates'),
  highProtein('High Protein', 'Muscle & recovery');

  const DietGoal(this.label, this.description);
  final String label;
  final String description;

  /// Returns true if this is the balanced (default) option
  bool get isBalanced => this == DietGoal.balanced;
}

/// Category for diet exclusions
enum ExclusionCategory { allergy, lifestyle }

/// Hard exclusions (allergies & lifestyle)
enum DietExclusion {
  // Allergies (medical) - show for everyone
  peanutFree('Peanut Free', ExclusionCategory.allergy),
  treeNutFree('Tree Nut Free', ExclusionCategory.allergy),
  glutenFree('Gluten Free', ExclusionCategory.allergy),
  wheatFree('Wheat Free', ExclusionCategory.allergy),
  dairyFree('Dairy Free', ExclusionCategory.allergy),
  eggFree('Egg Free', ExclusionCategory.allergy),
  soyFree('Soy Free', ExclusionCategory.allergy),
  fishFree('Fish Free', ExclusionCategory.allergy),
  shellfishFree('Shellfish Free', ExclusionCategory.allergy),
  sesameFree('Sesame Free', ExclusionCategory.allergy),

  // Lifestyle choices - universal ones for everyone
  noProcessedFoods('No Processed Foods', ExclusionCategory.lifestyle),
  noAddedSugar('No Added Sugar', ExclusionCategory.lifestyle),
  noOnionGarlic('No Onion/Garlic', ExclusionCategory.lifestyle),

  // Lifestyle choices - omnivores only (meat/seafood related)
  noSeafood('No Seafood', ExclusionCategory.lifestyle, omnivoreOnly: true),
  noRedMeat('No Red Meat', ExclusionCategory.lifestyle, omnivoreOnly: true);

  const DietExclusion(this.label, this.category, {this.omnivoreOnly = false});
  final String label;
  final ExclusionCategory category;
  final bool omnivoreOnly;

  bool get isAllergy => category == ExclusionCategory.allergy;
  bool get isLifestyle => category == ExclusionCategory.lifestyle;
}

/// Result from dietary preferences selection
class DietaryPreferencesResult {
  const DietaryPreferencesResult({
    required this.identity,
    this.vegDays = const {},
    this.exclusions = const {},
    this.customAllergies = const [],
    this.customLifestyle = const [],
    this.goals = const {},
  });

  final DietIdentity identity;
  final Set<int> vegDays; // 0=Sun, 6=Sat
  final Set<DietExclusion> exclusions;
  final List<String> customAllergies;
  final List<String> customLifestyle;
  final Set<DietGoal> goals;

  // Internal getters with null-safety for hot reload compatibility
  List<String> get _safeCustomAllergies => customAllergies;
  List<String> get _safeCustomLifestyle => customLifestyle;
  Set<DietGoal> get _safeGoals => goals;

  /// Format for display
  String get displayText {
    final parts = <String>[identity.label];
    if (vegDays.isNotEmpty) {
      parts.add('${vegDays.length} veg days');
    }
    // Use safe getters to handle null from old hot-reloaded instances
    final customAllergiesCount = _safeCustomAllergies.length;
    final customLifestyleCount = _safeCustomLifestyle.length;

    // Count allergies and lifestyle choices separately
    final allergyExclusions = exclusions.where((e) => e.isAllergy).length;
    final lifestyleExclusions = exclusions.where((e) => e.isLifestyle).length;

    final totalAllergies = allergyExclusions + customAllergiesCount;
    final totalLifestyle = lifestyleExclusions + customLifestyleCount;

    if (totalAllergies > 0) {
      parts.add(
        '$totalAllergies ${totalAllergies == 1 ? 'allergy' : 'allergies'}',
      );
    }
    if (totalLifestyle > 0) {
      parts.add('$totalLifestyle lifestyle');
    }
    final safeGoals = _safeGoals;
    if (safeGoals.isNotEmpty) {
      parts.add(safeGoals.map((g) => g.label).join(', '));
    }
    return parts.join(' • ');
  }

  @override
  String toString() => displayText;
}

/// A scrollable sheet for selecting dietary preferences using a smart funnel
class DietaryPreferencesSheet extends StatefulWidget {
  const DietaryPreferencesSheet({
    super.key,
    this.initialResult,
    required this.onSaved,
  });

  final DietaryPreferencesResult? initialResult;
  final ValueChanged<DietaryPreferencesResult> onSaved;

  /// Shows the dietary preferences picker as a modal bottom sheet
  static Future<DietaryPreferencesResult?> show({
    required BuildContext context,
    DietaryPreferencesResult? initialResult,
  }) async {
    return showModalBottomSheet<DietaryPreferencesResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DietaryPreferencesSheet(
        initialResult: initialResult,
        onSaved: (result) => Navigator.pop(context, result),
      ),
    );
  }

  @override
  State<DietaryPreferencesSheet> createState() =>
      _DietaryPreferencesSheetState();
}

class _DietaryPreferencesSheetState extends State<DietaryPreferencesSheet> {
  DietIdentity? _identity;
  Set<int> _vegDays = {};
  Set<DietExclusion> _exclusions = {};
  List<String> _customAllergies = [];
  List<String> _customLifestyle = [];
  Set<DietGoal> _goals = {};

  // Inline input state
  bool _showAllergyInput = false;
  bool _showLifestyleInput = false;
  final _allergyController = TextEditingController();
  final _lifestyleController = TextEditingController();
  final _allergyFocusNode = FocusNode();
  final _lifestyleFocusNode = FocusNode();

  // Sunday = 0, Saturday = 6
  static const _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const _vegDayColor = DietColors.vegDay;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialResult;
    if (initial != null) {
      _identity = initial.identity;
      _vegDays = Set.from(initial.vegDays);
      _exclusions = Set.from(initial.exclusions);
      _customAllergies = List.from(initial.customAllergies);
      _customLifestyle = List.from(initial.customLifestyle);
      _goals = Set.from(initial.goals);
    }
  }

  @override
  void dispose() {
    _allergyController.dispose();
    _lifestyleController.dispose();
    _allergyFocusNode.dispose();
    _lifestyleFocusNode.dispose();
    super.dispose();
  }

  /// Get valid lifestyle choices based on identity
  List<DietExclusion> get _validLifestyleChoices {
    if (_identity == null) return [];

    return DietExclusion.values.where((e) {
      if (!e.isLifestyle) return false;
      // Omnivore-only options only show for omnivores
      if (e.omnivoreOnly && _identity != DietIdentity.omnivore) return false;
      return true;
    }).toList();
  }

  /// Get valid allergies based on identity
  List<DietExclusion> get _validAllergies {
    if (_identity == null) return [];

    switch (_identity!) {
      case DietIdentity.vegan:
        // Vegans don't need dairy free - they don't eat dairy
        return DietExclusion.values
            .where((e) => e.isAllergy && e != DietExclusion.dairyFree)
            .toList();
      case DietIdentity.vegetarian:
      case DietIdentity.eggetarian:
      case DietIdentity.omnivore:
        // All allergies available
        return DietExclusion.values.where((e) => e.isAllergy).toList();
    }
  }

  /// Get all valid exclusions for cleaning
  Set<DietExclusion> get _allValidExclusions {
    return {..._validAllergies, ..._validLifestyleChoices};
  }

  /// Check if weekly rhythm section should show
  bool get _showWeeklyRhythm =>
      _identity == DietIdentity.omnivore ||
      _identity == DietIdentity.eggetarian;

  void _confirmSelection() {
    if (_identity == null) return;

    // Filter exclusions to only valid ones for current identity
    final cleanedExclusions = _exclusions.intersection(_allValidExclusions);

    widget.onSaved(
      DietaryPreferencesResult(
        identity: _identity!,
        vegDays: _showWeeklyRhythm ? _vegDays : {},
        exclusions: cleanedExclusions,
        customAllergies: _customAllergies,
        customLifestyle: _customLifestyle,
        goals: _goals,
      ),
    );
  }

  /// Sanitizes user input to prevent XSS and injection attacks
  String _sanitizeInput(String input) {
    // Remove HTML tags
    var sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');
    // Remove script-like patterns
    sanitized = sanitized.replaceAll(
      RegExp(r'javascript:', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'on\w+=', caseSensitive: false),
      '',
    );
    // Remove SQL injection patterns
    sanitized = sanitized.replaceAll(RegExp(r'''[';"]'''), '');
    // Limit length to prevent abuse
    if (sanitized.length > 50) {
      sanitized = sanitized.substring(0, 50);
    }
    return sanitized.trim();
  }

  void _submitAllergyInput() {
    final text = _allergyController.text.trim();
    if (text.isEmpty) {
      setState(() => _showAllergyInput = false);
      return;
    }

    final items = text
        .split(',')
        .map((s) => _sanitizeInput(s))
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      _customAllergies.addAll(items);
      _allergyController.clear();
      _showAllergyInput = false;
    });
  }

  void _submitLifestyleInput() {
    final text = _lifestyleController.text.trim();
    if (text.isEmpty) {
      setState(() => _showLifestyleInput = false);
      return;
    }

    final items = text
        .split(',')
        .map((s) => _sanitizeInput(s))
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      _customLifestyle.addAll(items);
      _lifestyleController.clear();
      _showLifestyleInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
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

          // Header
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
                        'Dietary Preferences',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'Help us personalize your nutrition',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: _identity != null ? _confirmSelection : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Layer 1: Base Identity
                  _buildSectionHeader(
                    context,
                    'What describes you best?',
                    'This helps filter your diet options',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildIdentityCards(colorScheme, textTheme),

                  // Layer 2: Weekly Rhythm (conditional)
                  if (_showWeeklyRhythm)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            'Weekly Rhythm',
                            'Any specific veg-only days?',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildWeekDayToggles(colorScheme, textTheme),
                        ],
                      ),
                    ),

                  // Layer 3: Lifestyle Choices (merged)
                  if (_identity != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            'Lifestyle Choices',
                            'Your dietary preferences',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildLifestyleChips(colorScheme, textTheme),
                          _buildLifestyleInlineInput(colorScheme, textTheme),
                        ],
                      ),
                    ),

                  // Layer 4: Allergies (everyone)
                  if (_identity != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            'Allergies',
                            'Medical restrictions we must respect',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildAllergyChips(colorScheme, textTheme),
                          _buildAllergyInlineInput(colorScheme, textTheme),
                        ],
                      ),
                    ),

                  // Layer 6: Diet Goal (conditional on identity)
                  if (_identity != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            'Diet Goal',
                            'Optional focus for your nutrition',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildGoalSelector(colorScheme, textTheme),
                        ],
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityCards(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: DietIdentity.values.map((identity) {
        final isSelected = _identity == identity;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _identity = identity;
                  // Clear invalid exclusions when identity changes
                  _exclusions = _exclusions.intersection(_allValidExclusions);
                  // Clear veg days if not applicable
                  if (!_showWeeklyRhythm) {
                    _vegDays = {};
                  }
                });
              },
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: AnimatedContainer(
                duration: AppSpacing.durationMedium,
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerLow,
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
                      width: AppSpacing.touchTargetMin,
                      height: AppSpacing.touchTargetMin,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? identity.color
                            : identity.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadiusSmall,
                        ),
                      ),
                      child: Icon(
                        identity.icon,
                        color: isSelected ? Colors.white : identity.color,
                        size: AppSpacing.iconSize,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            identity.label,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            identity.description,
                            style: textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimaryContainer.withValues(
                                      alpha: 0.8,
                                    )
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekDayToggles(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = _vegDays.contains(index);
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (isSelected) {
                _vegDays.remove(index);
              } else {
                _vegDays.add(index);
              }
            });
          },
          child: AnimatedContainer(
            duration: AppSpacing.durationFast,
            width: AppSpacing.touchTargetMin,
            height: AppSpacing.touchTargetMin,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? _vegDayColor
                  : colorScheme.surfaceContainerLow,
              border: Border.all(
                color: isSelected ? _vegDayColor : colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                _weekDays[index],
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLifestyleChips(ColorScheme colorScheme, TextTheme textTheme) {
    final validChoices = _validLifestyleChoices;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        // Standard lifestyle chips
        ...validChoices.map((choice) {
          final isSelected = _exclusions.contains(choice);
          return FilterChip(
            label: Text(choice.label),
            selected: isSelected,
            onSelected: (selected) {
              HapticFeedback.selectionClick();
              setState(() {
                if (selected) {
                  _exclusions.add(choice);
                } else {
                  _exclusions.remove(choice);
                }
              });
            },
            selectedColor: colorScheme.tertiaryContainer,
            checkmarkColor: colorScheme.onTertiaryContainer,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected
                  ? colorScheme.tertiary
                  : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          );
        }),
        // Custom lifestyle chips (deletable)
        ..._customLifestyle.map((custom) {
          return InputChip(
            label: Text(custom),
            onDeleted: () {
              HapticFeedback.selectionClick();
              setState(() => _customLifestyle.remove(custom));
            },
            backgroundColor: colorScheme.tertiaryContainer,
            deleteIconColor: colorScheme.onTertiaryContainer,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(color: colorScheme.tertiary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          );
        }),
        // "+ Other" chip or inline input
        if (!_showLifestyleInput)
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
              setState(() => _showLifestyleInput = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _lifestyleFocusNode.requestFocus();
              });
            },
            labelStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(color: colorScheme.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          ),
      ],
    );
  }

  Widget _buildLifestyleInlineInput(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return AnimatedSize(
      duration: AppSpacing.durationFast,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_showLifestyleInput
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: TextField(
                controller: _lifestyleController,
                focusNode: _lifestyleFocusNode,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'e.g., No Nightshades, Low FODMAP',
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
                    borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
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
                          _lifestyleController.clear();
                          setState(() => _showLifestyleInput = false);
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: _submitLifestyleInput,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) => _submitLifestyleInput(),
              ),
            ),
    );
  }

  Widget _buildAllergyChips(ColorScheme colorScheme, TextTheme textTheme) {
    final validAllergies = _validAllergies;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        // Standard allergy chips
        ...validAllergies.map((allergy) {
          final isSelected = _exclusions.contains(allergy);
          return FilterChip(
            label: Text(allergy.label),
            selected: isSelected,
            onSelected: (selected) {
              HapticFeedback.selectionClick();
              setState(() {
                if (selected) {
                  _exclusions.add(allergy);
                } else {
                  _exclusions.remove(allergy);
                }
              });
            },
            selectedColor: colorScheme.errorContainer,
            checkmarkColor: colorScheme.onErrorContainer,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onErrorContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected
                  ? colorScheme.error
                  : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          );
        }),
        // Custom allergy chips (deletable)
        ..._customAllergies.map((custom) {
          return InputChip(
            label: Text(custom),
            onDeleted: () {
              HapticFeedback.selectionClick();
              setState(() => _customAllergies.remove(custom));
            },
            backgroundColor: colorScheme.errorContainer,
            deleteIconColor: colorScheme.onErrorContainer,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(color: colorScheme.error, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          );
        }),
        // "+ Other" chip or inline input
        if (!_showAllergyInput)
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
              setState(() => _showAllergyInput = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _allergyFocusNode.requestFocus();
              });
            },
            labelStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(color: colorScheme.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          ),
      ],
    );
  }

  Widget _buildAllergyInlineInput(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return AnimatedSize(
      duration: AppSpacing.durationFast,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_showAllergyInput
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: TextField(
                controller: _allergyController,
                focusNode: _allergyFocusNode,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'e.g., Mustard, Celery, Corn',
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
                    borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
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
                          _allergyController.clear();
                          setState(() => _showAllergyInput = false);
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: _submitAllergyInput,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) => _submitAllergyInput(),
              ),
            ),
    );
  }

  Widget _buildGoalSelector(ColorScheme colorScheme, TextTheme textTheme) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: DietGoal.values.map((goal) {
        final isSelected = _goals.contains(goal);
        return FilterChip(
          label: Text(goal.label),
          selected: isSelected,
          onSelected: (selected) {
            HapticFeedback.selectionClick();
            setState(() {
              if (selected) {
                if (goal.isBalanced) {
                  // Selecting Balanced clears all other goals
                  _goals.clear();
                  _goals.add(DietGoal.balanced);
                } else {
                  // Selecting any specific goal removes Balanced
                  _goals.remove(DietGoal.balanced);
                  _goals.add(goal);
                }
              } else {
                _goals.remove(goal);
              }
            });
          },
          selectedColor: colorScheme.secondaryContainer,
          checkmarkColor: colorScheme.onSecondaryContainer,
          labelStyle: textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected
                ? colorScheme.secondary
                : colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        );
      }).toList(),
    );
  }
}
