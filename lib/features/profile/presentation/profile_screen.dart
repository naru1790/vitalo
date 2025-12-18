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
import '../../../core/widgets/location_picker_sheet.dart';
import '../../../core/widgets/dietary_preferences_sheet.dart';
import '../../../core/widgets/body_health_card.dart';
import '../../../core/widgets/profile_row.dart';
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
  bool _notificationsEnabled = true;

  // Personal info
  String? _gender;
  int? _birthYear;
  String? _country;
  String? _state;

  // Body & Health data
  BodyHealthData _bodyHealthData = const BodyHealthData();
  DietaryPreferencesResult? _dietaryPref;

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

                // Body & Health - new consolidated card
                BodyHealthCard(
                  data: _bodyHealthData,
                  onDataChanged: (data) {
                    setState(() => _bodyHealthData = data);
                    talker.info('Body health data updated');
                  },
                  isFemale: _gender?.toLowerCase() == 'female',
                ),

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
    return ProfileCard(
      child: Column(
        children: [
          GenderSelection(
            selectedGender: _gender,
            onGenderSelected: (value) {
              setState(() => _gender = value);
              talker.info('Gender set: $value');
            },
          ),

          const ProfileRowDivider(),

          ProfileTappableRow(
            icon: Icons.cake_outlined,
            label: 'Birth Year',
            value: _formatBirthYear(),
            onTap: _selectBirthYear,
          ),

          const ProfileRowDivider(),

          ProfileTappableRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: _formatLocation(),
            onTap: _selectLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryPreferenceCard(ColorScheme colorScheme) {
    final hasValue = _dietaryPref != null;
    return ProfileCard(
      child: ProfileTappableRow(
        icon: Icons.restaurant_menu_rounded,
        label: 'Dietary Preferences',
        value: hasValue ? null : 'Set up',
        subtitle: hasValue ? _formatDietaryPreference() : null,
        onTap: _selectDietaryPreference,
      ),
    );
  }

  Widget _buildPreferencesCard(ColorScheme colorScheme) {
    return ProfileCard(
      child: ProfileSwitchRow(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() => _notificationsEnabled = value);
          talker.info('Notifications: $value');
        },
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
    return ProfileCard(
      child: Column(
        children: [
          ProfileTappableRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => context.push(AppRoutes.privacy),
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () => context.push(AppRoutes.terms),
          ),
          const ProfileRowDivider(),
          ProfileTappableRow(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            iconColor: colorScheme.error,
            labelColor: colorScheme.error,
            onTap: _handleSignOut,
          ),
        ],
      ),
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
