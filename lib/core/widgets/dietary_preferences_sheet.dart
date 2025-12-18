import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
    CupertinoIcons.tree,
    DietColors.vegan,
  ),
  vegetarian(
    'Vegetarian',
    'No meat or fish, dairy is fine',
    CupertinoIcons.leaf_arrow_circlepath,
    DietColors.vegetarian,
  ),
  eggetarian(
    'Eggetarian',
    'Vegetarian diet that includes eggs',
    CupertinoIcons.circle_fill,
    DietColors.eggetarian,
  ),
  omnivore(
    'Omnivore',
    'Flexible diet, eats all food types',
    CupertinoIcons.square_grid_2x2_fill,
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
    return showCupertinoModalPopup<DietaryPreferencesResult>(
      context: context,
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
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Help us personalize your nutrition',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton.filled(
                      onPressed: _identity != null ? _confirmSelection : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.buttonRadius,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
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
                      _buildIdentityCards(context),

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
                              _buildWeekDayToggles(context),
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
                              _buildLifestyleChips(context),
                              _buildLifestyleInlineInput(context),
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
                              _buildAllergyChips(context),
                              _buildAllergyInlineInput(context),
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
                              _buildGoalSelector(context),
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
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(subtitle, style: TextStyle(fontSize: 15, color: secondaryLabel)),
      ],
    );
  }

  Widget _buildIdentityCards(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      children: DietIdentity.values.map((identity) {
        final isSelected = _identity == identity;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GestureDetector(
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
            child: AnimatedContainer(
              duration: AppSpacing.durationMedium,
              curve: Curves.easeOut,
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
                      color: isSelected
                          ? CupertinoColors.white
                          : identity.color,
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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? primaryColor : labelColor,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          identity.description,
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekDayToggles(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

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
              color: isSelected ? _vegDayColor : tertiaryFill,
              border: Border.all(
                color: isSelected ? _vegDayColor : separatorColor,
                width: isSelected ? 1.5 : LiquidGlass.borderWidth,
              ),
            ),
            child: Center(
              child: Text(
                _weekDays[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? CupertinoColors.white : secondaryLabel,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLifestyleChips(BuildContext context) {
    final validChoices = _validLifestyleChoices;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        // Standard lifestyle pills
        ...validChoices.map((choice) {
          final isSelected = _exclusions.contains(choice);
          return _IOSPill(
            label: choice.label,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _exclusions.remove(choice);
                } else {
                  _exclusions.add(choice);
                }
              });
            },
            selectedColor: DietColors.lifestyle,
            selectedBorderColor: DietColors.lifestyleBorder,
          );
        }),
        // Custom lifestyle pills (deletable)
        ..._customLifestyle.map((custom) {
          return _IOSDeletablePill(
            label: custom,
            onDeleted: () => setState(() => _customLifestyle.remove(custom)),
            backgroundColor: DietColors.lifestyle,
            borderColor: DietColors.lifestyleBorder,
          );
        }),
        // "+ Other" pill
        if (!_showLifestyleInput)
          _IOSActionPill(
            label: 'Other',
            onTap: () {
              setState(() => _showLifestyleInput = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _lifestyleFocusNode.requestFocus();
              });
            },
          ),
      ],
    );
  }

  Widget _buildLifestyleInlineInput(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return AnimatedSize(
      duration: AppSpacing.durationFast,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_showLifestyleInput
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _lifestyleController,
                      focusNode: _lifestyleFocusNode,
                      textCapitalization: TextCapitalization.words,
                      placeholder: 'e.g., No Nightshades, Low FODMAP',
                      placeholderStyle: TextStyle(
                        fontSize: 17,
                        color: secondaryLabel,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: tertiaryFill,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.inputRadius,
                        ),
                      ),
                      onSubmitted: (_) => _submitLifestyleInput(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    minSize: 0,
                    onPressed: () {
                      _lifestyleController.clear();
                      setState(() => _showLifestyleInput = false);
                    },
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: secondaryLabel,
                      size: 24,
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    minSize: 0,
                    onPressed: _submitLifestyleInput,
                    child: Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAllergyChips(BuildContext context) {
    final validAllergies = _validAllergies;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        // Standard allergy pills
        ...validAllergies.map((allergy) {
          final isSelected = _exclusions.contains(allergy);
          return _IOSPill(
            label: allergy.label,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _exclusions.remove(allergy);
                } else {
                  _exclusions.add(allergy);
                }
              });
            },
            selectedColor: DietColors.allergy,
            selectedBorderColor: DietColors.allergyBorder,
          );
        }),
        // Custom allergy pills (deletable)
        ..._customAllergies.map((custom) {
          return _IOSDeletablePill(
            label: custom,
            onDeleted: () => setState(() => _customAllergies.remove(custom)),
            backgroundColor: DietColors.allergy,
            borderColor: DietColors.allergyBorder,
          );
        }),
        // "+ Other" pill
        if (!_showAllergyInput)
          _IOSActionPill(
            label: 'Other',
            onTap: () {
              setState(() => _showAllergyInput = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _allergyFocusNode.requestFocus();
              });
            },
          ),
      ],
    );
  }

  Widget _buildAllergyInlineInput(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return AnimatedSize(
      duration: AppSpacing.durationFast,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_showAllergyInput
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _allergyController,
                      focusNode: _allergyFocusNode,
                      textCapitalization: TextCapitalization.words,
                      placeholder: 'e.g., Mustard, Celery, Corn',
                      placeholderStyle: TextStyle(
                        fontSize: 17,
                        color: secondaryLabel,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: tertiaryFill,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.inputRadius,
                        ),
                      ),
                      onSubmitted: (_) => _submitAllergyInput(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    minSize: 0,
                    onPressed: () {
                      _allergyController.clear();
                      setState(() => _showAllergyInput = false);
                    },
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: secondaryLabel,
                      size: 24,
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    minSize: 0,
                    onPressed: _submitAllergyInput,
                    child: Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGoalSelector(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: DietGoal.values.map((goal) {
        final isSelected = _goals.contains(goal);
        return _IOSPill(
          label: goal.label,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              if (!isSelected) {
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
          selectedColor: DietColors.goal,
          selectedBorderColor: DietColors.goalBorder,
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// iOS-STYLED PILL WIDGETS (Pure Cupertino - No Material Chips)
// ═══════════════════════════════════════════════════════════════════════════

/// iOS-styled selectable pill button (replaces FilterChip)
class _IOSPill extends StatelessWidget {
  const _IOSPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.selectedBorderColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color selectedBorderColor;

  @override
  Widget build(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : tertiaryFill,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusPill),
          border: Border.all(
            color: isSelected ? selectedBorderColor : separatorColor,
            width: isSelected ? 1.5 : LiquidGlass.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                CupertinoIcons.checkmark,
                size: 14,
                color: selectedBorderColor,
              ),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? selectedBorderColor : secondaryLabel,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// iOS-styled deletable pill (replaces InputChip)
class _IOSDeletablePill extends StatelessWidget {
  const _IOSDeletablePill({
    required this.label,
    required this.onDeleted,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final VoidCallback onDeleted;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.xs,
        top: AppSpacing.xxs,
        bottom: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusPill),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: borderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onDeleted();
            },
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              size: 18,
              color: borderColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// iOS-styled action pill with + icon (replaces ActionChip)
class _IOSActionPill extends StatelessWidget {
  const _IOSActionPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: tertiaryFill,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusPill),
          border: Border.all(
            color: separatorColor,
            width: LiquidGlass.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.plus, size: 16, color: secondaryLabel),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: secondaryLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
