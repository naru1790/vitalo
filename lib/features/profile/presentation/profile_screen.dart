import 'dart:io' show Platform;

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
import '../../../core/widgets/weight_picker_sheet.dart';
import '../../../core/widgets/height_picker_sheet.dart';
import '../../../core/widgets/location_picker_sheet.dart';
import '../../../core/widgets/dietary_preferences_sheet.dart';
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
  DietaryPreferencesResult? _dietaryPref;

  // Health integrations
  bool _healthConnected = false;
  bool _fitbitConnected = false;
  bool _garminConnected = false;

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
      return "$feet'$inches\""; // e.g. 5'10"
    }
  }

  Future<void> _selectWeight() async {
    final result = await WeightPickerSheet.show(
      context: context,
      initialWeight: _weightKg,
      initialUnit: _isMetric ? WeightUnit.kg : WeightUnit.lbs,
    );
    if (result != null && mounted) {
      setState(() => _weightKg = result.asKg);
      talker.info(
        'Weight set: ${result.value} ${result.unit.label} (${result.asKg.toStringAsFixed(1)} kg)',
      );
    }
  }

  Future<void> _selectHeight() async {
    final result = await HeightPickerSheet.show(
      context: context,
      initialHeightCm: _heightCm,
      initialUnit: _isMetric ? HeightUnit.cm : HeightUnit.ftIn,
    );
    if (result != null && mounted) {
      setState(() => _heightCm = result.valueCm);
      talker.info(
        'Height set: ${result.toString()} (${result.valueCm.toInt()} cm)',
      );
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

  String _formatDietaryPreference() {
    if (_dietaryPref == null) return 'Not Set';
    return _dietaryPref!.displayText;
  }

  Future<void> _selectDietaryPreference() async {
    final result = await DietaryPreferencesSheet.show(
      context: context,
      initialResult: _dietaryPref,
    );

    if (result != null && mounted) {
      setState(() => _dietaryPref = result);
      talker.info('Dietary preference set: ${result.displayText}');
    }
  }

  Future<void> _handleSignOut() async {
    talker.info('Sign out initiated');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: AppSpacing.touchTargetMin,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sign Out',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Are you sure you want to sign out?',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Single confirmation with DELETE typing
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      builder: (context) => _DeleteConfirmationSheet(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );

    if (confirmed == true && mounted) {
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
                _buildDietaryPreferenceCard(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Preferences', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildPreferencesCard(colorScheme),

                const SizedBox(height: AppSpacing.xl),

                _buildSectionTitle('Integrations', colorScheme),
                const SizedBox(height: AppSpacing.sm),
                _buildIntegrationsCard(colorScheme),

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
          _buildTappableRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: _formatWeight(),
            colorScheme: colorScheme,
            onTap: _selectWeight,
          ),

          _buildDivider(colorScheme),

          _buildTappableRow(
            icon: Icons.height_outlined,
            label: 'Height',
            value: _formatHeight(),
            colorScheme: colorScheme,
            onTap: _selectHeight,
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

  Widget _buildDietaryPreferenceCard(ColorScheme colorScheme) {
    final hasValue = _dietaryPref != null;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _selectDietaryPreference,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: AppSpacing.iconSizeSmall,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dietary Preferences',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (hasValue) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          _formatDietaryPreference(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!hasValue)
                  Text(
                    'Set up',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.chevron_right_rounded,
                  size: AppSpacing.iconSize,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildIntegrationsCard(ColorScheme colorScheme) {
    final isIOS = Platform.isIOS;
    final healthAppName = isIOS ? 'Apple Health' : 'Health Connect';
    const healthIcon = Icons.favorite_rounded;
    final healthIconColor = isIOS
        ? const Color(0xFFFF2D55)
        : const Color(0xFF4285F4);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          // Platform Health App (Apple Health / Health Connect)
          _buildIntegrationRow(
            icon: healthIcon,
            iconColor: healthIconColor,
            name: healthAppName,
            subtitle: 'Recommended • Syncs with 100+ apps',
            isConnected: _healthConnected,
            colorScheme: colorScheme,
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
          _buildDivider(colorScheme),
          // Fitbit
          _buildIntegrationRow(
            icon: Icons.watch_rounded,
            iconColor: const Color(0xFF00B0B9), // Fitbit teal
            name: 'Fitbit',
            subtitle: 'Steps, sleep & heart rate',
            isConnected: _fitbitConnected,
            colorScheme: colorScheme,
            onChanged: (value) {
              setState(() => _fitbitConnected = value);
              talker.info('Fitbit: ${value ? 'Connected' : 'Disconnected'}');
              if (value) {
                _showComingSoonDialog('Fitbit');
                setState(() => _fitbitConnected = false);
              }
            },
          ),
          _buildDivider(colorScheme),
          // Garmin
          _buildIntegrationRow(
            icon: Icons.watch_rounded,
            iconColor: const Color(0xFF007CC3), // Garmin blue
            name: 'Garmin',
            subtitle: 'Activities & fitness data',
            isConnected: _garminConnected,
            colorScheme: colorScheme,
            onChanged: (value) {
              setState(() => _garminConnected = value);
              talker.info('Garmin: ${value ? 'Connected' : 'Disconnected'}');
              if (value) {
                _showComingSoonDialog('Garmin');
                setState(() => _garminConnected = false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationRow({
    required IconData icon,
    required Color iconColor,
    required String name,
    required String subtitle,
    required bool isConnected,
    required ColorScheme colorScheme,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSpacing.iconSizeSmall, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  isConnected ? 'Connected' : subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isConnected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isConnected,
            activeTrackColor: colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String serviceName) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.construction_rounded, color: colorScheme.tertiary),
        title: const Text('Coming Soon'),
        content: Text(
          '$serviceName integration is coming in a future update!\n\n'
          'For now, you can sync $serviceName data through '
          '${Platform.isIOS ? 'Apple Health' : 'Health Connect'} instead.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showHealthPermissionsInfo(String healthAppName) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.info_outline_rounded, color: colorScheme.primary),
        title: Text('$healthAppName Integration'),
        content: const Text(
          'Vitalo will request permission to read and write:\n\n'
          '• Weight\n'
          '• Height\n'
          '• Steps\n'
          '• Active calories\n\n'
          'You can manage these permissions anytime in your device settings.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
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
          _buildTappableRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            colorScheme: colorScheme,
            onTap: () => context.push(AppRoutes.privacy),
          ),
          _buildDivider(colorScheme),
          _buildTappableRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            colorScheme: colorScheme,
            onTap: () => context.push(AppRoutes.terms),
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
    final hasValue = value != null && value != 'Not Set';

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
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelColor ?? colorScheme.onSurface,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: hasValue
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
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

/// Bottom sheet for DELETE confirmation with real-time validation
class _DeleteConfirmationSheet extends StatefulWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DeleteConfirmationSheet({
    required this.colorScheme,
    required this.textTheme,
  });

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
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: widget.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Icon(
            Icons.delete_forever_rounded,
            color: widget.colorScheme.error,
            size: AppSpacing.touchTargetMin,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Delete Account',
            style: widget.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This will permanently delete your account and all data. This action cannot be undone.',
            style: widget.textTheme.bodyMedium?.copyWith(
              color: widget.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Type DELETE to confirm',
            style: widget.textTheme.labelMedium?.copyWith(
              color: widget.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            style: widget.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: widget.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'DELETE',
              hintStyle: widget.textTheme.titleMedium?.copyWith(
                color: widget.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                letterSpacing: 2,
              ),
              filled: true,
              fillColor: widget.colorScheme.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(
                  color: widget.colorScheme.error.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: _isValid
                      ? () => Navigator.pop(context, true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.colorScheme.error,
                    foregroundColor: widget.colorScheme.onError,
                    disabledBackgroundColor: widget.colorScheme.error
                        .withValues(alpha: 0.38),
                    disabledForegroundColor: widget.colorScheme.onError
                        .withValues(alpha: 0.38),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: const Text('Delete Forever'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
