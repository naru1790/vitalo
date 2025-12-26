import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/lifestyle_card.dart';
import '../../../core/widgets/coaching_card.dart';
import '../../../core/widgets/profile_row.dart';
import '../../../core/widgets/height_picker_sheet.dart';
import '../../../core/widgets/weight_picker_sheet.dart';
import '../../../core/widgets/wheel_picker.dart';
import '../../../design/design.dart';
import '../repositories/location_repository.dart';
import 'widgets/profile_body_health_section.dart';
import 'widgets/profile_personal_info_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _locationRepository = LocationRepository();

  /// Popular country codes shown at top of location picker.
  static const _popularCountryCodes = [
    'US', // United States
    'GB', // United Kingdom
    'CA', // Canada
    'AU', // Australia
    'IN', // India
    'DE', // Germany
    'FR', // France
    'JP', // Japan
    'BR', // Brazil
    'MX', // Mexico
  ];

  // User name for header
  String? _displayName;

  // User preferences
  bool _notificationsEnabled = true;

  // Personal info
  AppGender _gender = AppGender.male;
  int? _birthYear;
  String? _country;
  String? _countryCode;
  String? _state;
  String? _stateCode;

  // Body & Health data
  BodyHealthData _bodyHealthData = const BodyHealthData();
  AppUnitSystem _bodyHealthUnitSystem = AppUnitSystem.metric;

  // Lifestyle data (activity, sleep, diet)
  LifestyleData _lifestyleData = const LifestyleData();

  // Coaching data (goal, coach style)
  CoachingData _coachingData = const CoachingData();

  // Health integrations
  bool _healthConnected = false;

  @override
  void initState() {
    super.initState();
    talker.info('Profile screen opened');
    _loadUserMetadata();
  }

  @override
  void dispose() {
    talker.debug('Profile screen disposed');
    super.dispose();
  }

  void _loadUserMetadata() {
    final user = _authService.currentUser;
    if (user != null) {
      final metadata = user.userMetadata;
      if (metadata != null) {
        final name =
            metadata['full_name'] as String? ??
            metadata['name'] as String? ??
            metadata['display_name'] as String?;
        if (name != null && name.isNotEmpty) {
          setState(() => _displayName = name);
        }
        talker.debug('Loaded user metadata: name=$name');
      }
    }
  }

  Future<bool> _saveDisplayName(String newName) async {
    // TODO: Implement profile table update once fields are added
    // For now, just update local state
    talker.info('Name update requested: $newName (pending profile table)');
    setState(() => _displayName = newName);
    return true;
  }

  String _getDisplayName() {
    if (_displayName != null && _displayName!.isNotEmpty) {
      return _displayName!;
    }
    final user = _authService.currentUser;
    if (user?.email != null) {
      final emailPart = user!.email!.split('@')[0];
      return emailPart.isNotEmpty
          ? '${emailPart[0].toUpperCase()}${emailPart.substring(1)}'
          : 'User';
    }
    return 'Guest';
  }

  String _getUserEmail() {
    return _authService.currentUser?.email ?? 'Not signed in';
  }

  String _birthYearLabel() {
    if (_birthYear == null) return 'Not Set';
    final currentYear = DateTime.now().year;
    final age = currentYear - _birthYear!;
    return '$_birthYear ($age years)';
  }

  String _locationLabel() {
    if (_country == null) return 'Not Set';
    if (_state != null) return '$_state, $_country';
    return _country!;
  }

  void _setBodyHealthUnitSystem(AppUnitSystem value) {
    setState(() => _bodyHealthUnitSystem = value);
    talker.info('Body health unit system updated');
  }

  Future<void> _editWeight() async {
    final result = await WeightPickerSheet.show(
      context: context,
      initialWeight: _bodyHealthData.weightKg,
      initialUnit: _bodyHealthUnitSystem == AppUnitSystem.metric
          ? WeightUnit.kg
          : WeightUnit.lbs,
    );

    if (result != null && mounted) {
      setState(() {
        _bodyHealthData = _bodyHealthData.copyWith(weightKg: result.asKg);
      });
      talker.info('Weight updated');
    }
  }

  Future<void> _editHeight() async {
    final result = await HeightPickerSheet.show(
      context: context,
      initialHeightCm: _bodyHealthData.heightCm,
      initialUnit: _bodyHealthUnitSystem == AppUnitSystem.metric
          ? HeightUnit.cm
          : HeightUnit.ftIn,
    );

    if (result != null && mounted) {
      setState(() {
        _bodyHealthData = _bodyHealthData.copyWith(heightCm: result.valueCm);
      });
      talker.info('Height updated');
    }
  }

  Future<void> _editWaist() async {
    final result = await showCupertinoModalPopup<double?>(
      context: context,
      builder: (context) => _WaistPickerSheet(
        initialValue: _bodyHealthData.waistCm,
        isMetric: _bodyHealthUnitSystem == AppUnitSystem.metric,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _bodyHealthData = _bodyHealthData.copyWith(waistCm: result);
      });
      talker.info('Waist updated');
    }
  }

  Future<void> _editHealthConditions() async {
    final result = await showCupertinoModalPopup<BodyHealthData?>(
      context: context,
      builder: (context) =>
          _HealthConditionsSheet(data: _bodyHealthData, gender: _gender),
    );

    if (result != null && mounted) {
      setState(() {
        _bodyHealthData = result;
      });
      talker.info('Health conditions updated');
    }
  }

  Future<void> _selectBirthYear() async {
    // Feature code owns time resolution
    final currentYear = DateTime.now().year;
    // Default to 30 years ago if no birth year set
    final initialYear = _birthYear ?? (currentYear - 30);

    final result = await AppBottomSheet.show<int>(
      context,
      sheet: SheetPage(
        child: AppYearPickerSheet(
          currentYear: currentYear,
          initialYear: initialYear,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _birthYear = result);
      talker.info('Birth year set: $result');
    }
  }

  Future<void> _selectLocation() async {
    // Load countries from repository (feature layer owns data loading)
    // Parallelize independent data fetches to minimize cold start latency
    final results = await Future.wait([
      _locationRepository.getCountries(),
      _locationRepository.getPopularCountries(_popularCountryCodes),
    ]);

    final countries = results[0];
    final popularCountries = results[1];

    if (!mounted) return;

    final result = await AppBottomSheet.show<LocationResult>(
      context,
      sheet: SheetPage(
        child: AppLocationPickerSheet(
          countries: countries,
          popularCountries: popularCountries,
          statesLoader: _locationRepository.getStates,
          initialCountryCode: _countryCode,
          initialStateCode: _stateCode,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _country = result.countryName;
        _countryCode = result.countryCode;
        _state = result.stateName;
        _stateCode = result.stateCode;
      });
      talker.info('Location set: ${result.displayWithFlag}');
    }
  }

  Future<void> _handleSignOut() async {
    talker.info('Sign out initiated');

    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Sign Out'),
        message: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final error = await _authService.signOut();
      if (error != null && mounted) {
        talker.warning('Sign out failed: $error');
        AppErrorFeedback.show(context, error);
      } else if (mounted) {
        talker.info('Sign out successful');
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    talker.info('Delete account initiated');
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Single confirmation with DELETE typing - Liquid Glass style
    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              // Glass tint - more transparent in dark mode
              color: isDark
                  ? CupertinoColors.systemBackground
                        .resolveFrom(context)
                        .withValues(alpha: 0.7)
                  : CupertinoColors.systemBackground
                        .resolveFrom(context)
                        .withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadiusLarge),
              ),
              // Subtle glass edge
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.separator
                      .resolveFrom(context)
                      .withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: const SafeArea(
              top: false,
              child: _DeleteConfirmationSheet(),
            ),
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      talker.info('Account deletion confirmed');
      // Informational/warning global feedback is forbidden by contract.
    }
  }

  @override
  Widget build(BuildContext context) {
    return HubPage(
      title: 'Profile',
      leadingAction: const AppBarBackAction(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ProfileIdentityHeader(
              displayName: _displayName ?? _getDisplayName(),
              email: _getUserEmail(),
              avatarInitial: _getDisplayName().isNotEmpty
                  ? _getDisplayName()[0].toUpperCase()
                  : '?',
              onDisplayNameSave: _saveDisplayName,
            ),
          ),

          AppSection(
            title: 'Personal Info',
            child: ProfilePersonalInfoSection(
              gender: _gender,
              onGenderChanged: (value) {
                setState(() => _gender = value);
                talker.info('Gender set: $value');
              },
              birthYearLabel: _birthYearLabel(),
              isBirthYearPlaceholder: _birthYear == null,
              onBirthYearTap: _selectBirthYear,
              locationLabel: _locationLabel(),
              isLocationPlaceholder: _country == null,
              onLocationTap: _selectLocation,
            ),
          ),

          AppSection(
            title: 'Body & Health',
            child: ProfileBodyHealthSection(
              heightLabel: _bodyHealthData.heightLabel(_bodyHealthUnitSystem),
              weightLabel: _bodyHealthData.weightLabel(_bodyHealthUnitSystem),
              waistLabel: _bodyHealthData.waistLabel(_bodyHealthUnitSystem),
              unitSystem: _bodyHealthUnitSystem,
              healthConditionsValue: _bodyHealthData.hasNoConditions
                  ? 'I\'m healthy'
                  : null,
              healthConditionsSubtitle: _bodyHealthData.hasNoConditions
                  ? null
                  : _bodyHealthData.conditionsSummary,
              onHeightTap: _editHeight,
              onWeightTap: _editWeight,
              onWaistTap: _editWaist,
              onUnitSystemChanged: _setBodyHealthUnitSystem,
              onHealthConditionsTap: _editHealthConditions,
            ),
          ),

          // Lifestyle - activity, sleep, diet
          LifestyleCard(
            data: _lifestyleData,
            onDataChanged: (data) {
              setState(() => _lifestyleData = data);
              talker.info('Lifestyle data updated');
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Coaching - goal and coach personality
          CoachingCard(
            data: _coachingData,
            onDataChanged: (data) {
              setState(() => _coachingData = data);
              talker.info('Coaching data updated');
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionTitle('Preferences'),
          const SizedBox(height: AppSpacing.sm),
          _buildPreferencesCard(),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionTitle('Integrations'),
          const SizedBox(height: AppSpacing.sm),
          _buildIntegrationsCard(),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionTitle('Account'),
          const SizedBox(height: AppSpacing.sm),
          _buildAccountCard(),

          const SizedBox(height: AppSpacing.xxl),

          Center(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _handleDeleteAccount,
              child: Text(
                'Delete My Account',
                style: AppleTextStyles.footnoteSecondary(context),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxs),
      child: Text(title, style: AppleTextStyles.headline(context)),
    );
  }

  Widget _buildPreferencesCard() {
    return ProfileCard(
      child: ProfileSwitchRow(
        icon: CupertinoIcons.bell,
        label: 'Notifications',
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() => _notificationsEnabled = value);
          talker.info('Notifications: $value');
        },
      ),
    );
  }

  Widget _buildIntegrationsCard() {
    final isIOS = Platform.isIOS;
    final healthAppName = isIOS ? 'Apple Health' : 'Health Connect';
    const healthIcon = CupertinoIcons.heart_fill;
    final healthIconColor = isIOS
        ? BrandColors.appleHealth
        : BrandColors.healthConnect;

    return ProfileCard(
      child: ProfileSwitchRow(
        icon: healthIcon,
        iconColor: healthIconColor,
        label: healthAppName,
        subtitle: 'Recommended • Syncs with 100+ apps',
        value: _healthConnected,
        onChanged: (value) {
          setState(() => _healthConnected = value);
          talker.info(
            '$healthAppName: ${value ? 'Connected' : 'Disconnected'}',
          );
          if (value) {
            _showHealthPermissionsInfo(healthAppName);
          }
        },
      ),
    );
  }

  void _showHealthPermissionsInfo(String healthAppName) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.info, color: primaryColor, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text('$healthAppName Integration'),
          ],
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: AppSpacing.sm),
          child: Text(
            'Vitalo will request permission to read and write:\n\n'
            '• Weight\n'
            '• Height\n'
            '• Steps\n'
            '• Active calories\n\n'
            'You can manage these permissions anytime in your device settings.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    final errorColor = CupertinoColors.systemRed.resolveFrom(context);

    return ProfileCard(
      child: Column(
        children: [
          ProfileTappableRow(
            icon: CupertinoIcons.shield,
            label: 'Privacy Policy',
            onTap: () => context.push(AppRoutes.privacy),
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: CupertinoIcons.doc_text,
            label: 'Terms of Service',
            onTap: () => context.push(AppRoutes.terms),
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: CupertinoIcons.square_arrow_right,
            label: 'Sign Out',
            iconColor: errorColor,
            labelColor: errorColor,
            onTap: _handleSignOut,
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Body & Health models + edit sheets (owned by ProfileScreen)
// ───────────────────────────────────────────────────────────────────────────

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

/// Bottom sheet for DELETE confirmation with real-time validation
class _DeleteConfirmationSheet extends StatefulWidget {
  const _DeleteConfirmationSheet();

  @override
  State<_DeleteConfirmationSheet> createState() =>
      _DeleteConfirmationSheetState();
}

class _DeleteConfirmationSheetState extends State<_DeleteConfirmationSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  void _validateInput() {
    final isValid = _controller.text.trim().toUpperCase() == 'DELETE';
    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final errorColor = CupertinoColors.systemRed.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryLabel = CupertinoColors.tertiaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: separatorColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Warning icon in a subtle container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: errorColor,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Delete Account', style: AppleTextStyles.title3(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This will permanently delete your account and all data. This action cannot be undone.',
            style: AppleTextStyles.subhead(
              context,
            ).copyWith(color: secondaryLabel),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Input section with glass styling
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? CupertinoColors.systemGrey6
                        .resolveFrom(context)
                        .withValues(alpha: 0.5)
                  : CupertinoColors.systemGrey6.resolveFrom(context),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: separatorColor.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Type DELETE to confirm',
                  style: AppleTextStyles.footnote(context).copyWith(
                    color: secondaryLabel,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                CupertinoTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: AppleTextStyles.headline(context).copyWith(
                    letterSpacing: 4,
                    color: _isValid ? errorColor : null,
                  ),
                  placeholder: 'DELETE',
                  placeholderStyle: AppleTextStyles.headline(
                    context,
                  ).copyWith(color: tertiaryLabel, letterSpacing: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(
                      context,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                    border: Border.all(
                      color: _isValid
                          ? errorColor.withValues(alpha: 0.6)
                          : separatorColor,
                      width: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Action buttons - Apple HIG style (stacked for destructive actions)
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              color: _isValid ? errorColor : errorColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              onPressed: _isValid ? () => Navigator.pop(context, true) : null,
              child: Text(
                'Delete Account',
                style: TextStyle(
                  color: _isValid
                      ? CupertinoColors.white
                      : CupertinoColors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppleTextStyles.body(
                  context,
                ).copyWith(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
