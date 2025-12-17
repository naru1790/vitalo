import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_segmented_button.dart';
import '../../../core/widgets/inline_editable_header.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/year_picker_sheet.dart';
import '../../../core/widgets/location_picker_sheet.dart';
import 'widgets/gender_selection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  // User name for header
  String? _displayName;

  // User preferences
  bool _isMetric = true;
  bool _notificationsEnabled = true;

  // Personal info
  String? _gender;
  int? _birthYear;
  String? _country;
  String? _state;

  // Health data - null means "Not Set"
  double? _weightKg;
  double? _heightCm;
  String? _dietaryPref;

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

  bool _isGuest() {
    return _authService.currentUser?.email == null;
  }

  String _formatWeight() {
    if (_weightKg == null) return 'Not Set';
    if (_isMetric) {
      return '${_weightKg!.toStringAsFixed(1)} kg';
    } else {
      return '${(_weightKg! * 2.205).toStringAsFixed(1)} lbs';
    }
  }

  String _formatHeight() {
    if (_heightCm == null) return 'Not Set';
    if (_isMetric) {
      return '${_heightCm!.toInt()} cm';
    } else {
      final totalInches = _heightCm! / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return "$feet'$inches\"";
    }
  }

  String _formatBirthYear() {
    if (_birthYear == null) return 'Not Set';
    final age = _calculateAge();
    final ageStr = age != null ? ' ($age yrs)' : '';
    return '$_birthYear$ageStr';
  }

  int? _calculateAge() {
    if (_birthYear == null) return null;
    final now = DateTime.now();
    return now.year - _birthYear!;
  }

  Future<void> _selectBirthYear() async {
    final selectedYear = await YearPickerSheet.show(
      context: context,
      initialYear: _birthYear,
    );

    if (selectedYear != null) {
      setState(() => _birthYear = selectedYear);
      talker.info('Birth year set: $_birthYear');
    }
  }

  String _formatLocation() {
    if (_country == null) return 'Not Set';
    if (_state != null) return '$_state, $_country';
    return _country!;
  }

  Future<void> _selectLocation() async {
    final result = await LocationPickerSheet.show(
      context: context,
      // Note: We store country name, but the picker now expects ISO codes
      // For now, pass null for initial values until we store codes
    );

    if (result != null) {
      setState(() {
        _country = result.countryName;
        _state = result.stateName;
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
        message: const Text('Are you sure you want to sign out?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: const Text('Sign Out'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final error = await _authService.signOut();
      if (error != null && mounted) {
        talker.warning('Sign out failed: $error');
        AppSnackBar.showError(context, error);
      } else if (mounted) {
        talker.info('Sign out successful');
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    talker.info('Delete account initiated');

    final firstConfirm = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Delete Account'),
        message: const Text(
          'This will permanently delete your account and all data. This cannot be undone.',
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: const Text('Delete My Account'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (firstConfirm != true || !mounted) return;

    // Second confirmation
    final typeController = TextEditingController();

    final secondConfirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Type DELETE to confirm'),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: CupertinoTextField(
            controller: typeController,
            placeholder: 'DELETE',
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (typeController.text.trim().toUpperCase() == 'DELETE') {
                Navigator.pop(context, true);
              } else {
                AppSnackBar.showWarning(context, 'Type DELETE to confirm');
              }
            },
            isDestructiveAction: true,
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );

    if (secondConfirm == true && mounted) {
      talker.info('Account deletion confirmed');
      AppSnackBar.showWarning(context, 'Account deletion coming soon.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colorScheme.onSurface,
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(child: _buildHeader(colorScheme)),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.lg),

                _buildSectionTitle('Personal Info', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildPersonalInfoCard(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Body Metrics', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildBodyMetricsCard(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Dietary Preference', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildDietaryChips(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Preferences', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildPreferencesCard(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Account', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildAccountCard(colorScheme),

                const SizedBox(height: AppSpacing.xxl),

                Center(
                  child: TextButton(
                    onPressed: _handleDeleteAccount,
                    child: Text(
                      'Delete My Account',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.avatarSizeLarge,
            height: AppSpacing.avatarSizeLarge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerLow,
              border: Border.all(color: colorScheme.primary, width: 3),
            ),
            child: Center(
              child: Text(
                _getDisplayName().isNotEmpty
                    ? _getDisplayName()[0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InlineEditableHeader(
            initialText: _displayName ?? _getDisplayName(),
            onSave: _saveDisplayName,
            placeholder: 'Add your name',
            fontSize: 22,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _getUserEmail(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxs),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          GenderSelection(
            selectedGender: _gender,
            onGenderSelected: (value) {
              setState(() => _gender = value);
              talker.info('Gender set: $value');
            },
          ),

          _buildDivider(colorScheme),

          _buildTappableRow(
            icon: Icons.cake_outlined,
            label: 'Birth Year',
            value: _formatBirthYear(),
            colorScheme: colorScheme,
            onTap: _selectBirthYear,
          ),

          _buildDivider(colorScheme),

          _buildTappableRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: _formatLocation(),
            colorScheme: colorScheme,
            onTap: _selectLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMetricsCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          _buildStepperRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: _weightKg,
            unit: _isMetric ? 'kg' : 'lbs',
            displayValue: _formatWeight(),
            colorScheme: colorScheme,
            onIncrement: () {
              setState(() => _weightKg = (_weightKg ?? 70) + 0.5);
              talker.debug('Weight: $_weightKg kg');
            },
            onDecrement: () {
              setState(() {
                if (_weightKg != null && _weightKg! > 30) {
                  _weightKg = _weightKg! - 0.5;
                }
              });
              talker.debug('Weight: $_weightKg kg');
            },
            onClear: _weightKg != null
                ? () {
                    setState(() => _weightKg = null);
                    talker.debug('Weight cleared');
                  }
                : null,
          ),

          _buildDivider(colorScheme),

          _buildStepperRow(
            icon: Icons.height_outlined,
            label: 'Height',
            value: _heightCm,
            unit: _isMetric ? 'cm' : 'ft',
            displayValue: _formatHeight(),
            colorScheme: colorScheme,
            onIncrement: () {
              setState(() => _heightCm = (_heightCm ?? 170) + 1);
              talker.debug('Height: $_heightCm cm');
            },
            onDecrement: () {
              setState(() {
                if (_heightCm != null && _heightCm! > 100) {
                  _heightCm = _heightCm! - 1;
                }
              });
              talker.debug('Height: $_heightCm cm');
            },
            onClear: _heightCm != null
                ? () {
                    setState(() => _heightCm = null);
                    talker.debug('Height cleared');
                  }
                : null,
          ),

          _buildDivider(colorScheme),

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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                _buildSegmentedControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryChips(ColorScheme colorScheme) {
    final options = [
      ('🌱', 'Vegetarian'),
      ('🥗', 'Eggetarian'),
      ('🍗', 'Non-Veg'),
      ('🌿', 'Vegan'),
      ('🐟', 'Pescatarian'),
      ('🥩', 'Keto'),
      ('🍖', 'Paleo'),
      ('☪️', 'Halal'),
      ('✡️', 'Kosher'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_dietaryPref == null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'Select your dietary preference',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: options.map((option) {
              final isSelected = _dietaryPref == option.$2;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(option.$1),
                    const SizedBox(width: AppSpacing.xs),
                    Text(option.$2),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _dietaryPref = selected ? option.$2 : null;
                  });
                  talker.info('Dietary preference: $_dietaryPref');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              size: AppSpacing.iconSizeSmall,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Notifications',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
            ),
            Switch.adaptive(
              value: _notificationsEnabled,
              activeTrackColor: colorScheme.primary,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
                talker.info('Notifications: $value');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          if (_isGuest()) ...[
            _buildTappableRow(
              icon: Icons.link_rounded,
              label: 'Link Google Account',
              value: 'Save your progress',
              colorScheme: colorScheme,
              onTap: () {
                talker.info('Link account tapped');
              },
            ),
            _buildDivider(colorScheme),
          ],
          _buildTappableRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            colorScheme: colorScheme,
            onTap: () => context.push(AppRoutes.privacy),
          ),
          _buildDivider(colorScheme),
          _buildTappableRow(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            colorScheme: colorScheme,
            iconColor: colorScheme.error,
            labelColor: colorScheme.error,
            onTap: _handleSignOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: AppSpacing.touchTargetMin + AppSpacing.xxs,
      color: colorScheme.outlineVariant,
    );
  }

  Widget _buildChipSelector({
    required IconData icon,
    required String label,
    required List<String> options,
    required String? selected,
    required ColorScheme colorScheme,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSizeSmall,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((option) {
                  final isSelected = selected == option;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: GestureDetector(
                      onTap: () => onSelected(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : colorScheme.outlineVariant,
                          ),
                        ),
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTappableRow({
    required IconData icon,
    required String label,
    String? value,
    required ColorScheme colorScheme,
    Color? iconColor,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSpacing.iconSizeSmall,
              color: iconColor ?? colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: labelColor ?? colorScheme.onSurface,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSpacing.iconSizeSmall,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperRow({
    required IconData icon,
    required String label,
    required double? value,
    required String unit,
    required String displayValue,
    required ColorScheme colorScheme,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    VoidCallback? onClear,
  }) {
    final isSet = value != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSizeSmall,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSet
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSet ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepperButton(
                  icon: Icons.remove,
                  onTap: isSet ? onDecrement : null,
                  colorScheme: colorScheme,
                ),
                Container(
                  width: 1,
                  height: AppSpacing.xl,
                  color: colorScheme.outlineVariant,
                ),
                _buildStepperButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: AppSpacing.xs),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close_rounded,
                size: AppSpacing.iconSizeSmall,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    VoidCallback? onTap,
    required ColorScheme colorScheme,
  }) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          icon,
          size: AppSpacing.iconSizeSmall,
          color: isDisabled
              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.3)
              : colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return AppSegmentedButton<bool>(
      segments: const [
        ButtonSegment<bool>(value: true, label: Text('Metric')),
        ButtonSegment<bool>(value: false, label: Text('Imperial')),
      ],
      selected: {_isMetric},
      onSelectionChanged: (Set<bool> newSelection) {
        setState(() => _isMetric = newSelection.first);
        talker.info('Unit: ${_isMetric ? 'Metric' : 'Imperial'}');
      },
    );
  }
}
