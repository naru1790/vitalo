import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/profile_row.dart';
import '../../../design/design.dart';
import '../../../design/tokens/icons.dart' as icons;
import '../flows/body_measurements_flows.dart';
import '../flows/identity_flows.dart';
import '../flows/personal_info_flows.dart';
import '../models/body_measurements_data.dart';
import '../models/body_measurements_formatter.dart';
import 'widgets/profile_body_measurements_section.dart';
import 'widgets/profile_personal_info_section.dart';

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
  AppGender _gender = AppGender.male;
  int? _birthYear;

  // Body Measurements data
  BodyMeasurementsData _bodyMeasurementsData = const BodyMeasurementsData();

  // Measurement unit system is a global user preference.
  // Body Measurements consumes this value but does not own it.
  AppUnitSystem _unitSystem = AppUnitSystem.metric;

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
    // For now, just update local state
    talker.info('Name update requested: $newName (pending profile table)');
    setState(() => _displayName = newName);
    return true;
  }

  Future<void> _editDisplayName() async {
    final result = await IdentityFlows.editDisplayName(
      context: context,
      initialText: _displayName ?? _getDisplayName(),
      onSave: _saveDisplayName,
      placeholder: 'Add name',
    );

    if (result != null && mounted) {
      setState(() => _displayName = result);
      talker.info('Display name updated');
    }
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

  void _setUnitSystem(AppUnitSystem value) {
    setState(() => _unitSystem = value);
    talker.info('Unit system updated');
  }

  Future<void> _editWeight() async {
    final result = await BodyMeasurementsFlows.editWeight(
      context: context,
      initialKg: _bodyMeasurementsData.weightKg,
      unitSystem: _unitSystem,
    );

    if (result != null && mounted) {
      setState(() {
        _bodyMeasurementsData = _bodyMeasurementsData.copyWith(
          weightKg: result,
        );
      });
      talker.info('Weight updated');
    }
  }

  Future<void> _editHeight() async {
    final result = await BodyMeasurementsFlows.editHeight(
      context: context,
      initialCm: _bodyMeasurementsData.heightCm,
      unitSystem: _unitSystem,
    );

    if (result != null && mounted) {
      setState(() {
        _bodyMeasurementsData = _bodyMeasurementsData.copyWith(
          heightCm: result,
        );
      });
      talker.info('Height updated');
    }
  }

  Future<void> _editWaist() async {
    final result = await BodyMeasurementsFlows.editWaist(
      context: context,
      initialCm: _bodyMeasurementsData.waistCm,
      unitSystem: _unitSystem,
    );

    if (result != null && mounted) {
      setState(() {
        _bodyMeasurementsData = _bodyMeasurementsData.copyWith(waistCm: result);
      });
      talker.info('Waist updated');
    }
  }

  Future<void> _selectBirthYear() async {
    final result = await PersonalInfoFlows.selectBirthYear(
      context: context,
      initialYear: _birthYear,
    );

    if (result != null && mounted) {
      setState(() => _birthYear = result);
      talker.info('Birth year set: $result');
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
              onEditDisplayName: _editDisplayName,
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
            ),
          ),

          AppSection(
            title: 'Body Measurements',
            child: ProfileBodyMeasurementsSection(
              heightLabel: BodyMeasurementsFormatter.heightLabel(
                heightCm: _bodyMeasurementsData.heightCm,
                unitSystem: _unitSystem,
              ),
              weightLabel: BodyMeasurementsFormatter.weightLabel(
                weightKg: _bodyMeasurementsData.weightKg,
                unitSystem: _unitSystem,
              ),
              waistLabel: BodyMeasurementsFormatter.waistLabel(
                waistCm: _bodyMeasurementsData.waistCm,
                unitSystem: _unitSystem,
              ),
              onHeightTap: _editHeight,
              onWeightTap: _editWeight,
              onWaistTap: _editWaist,
            ),
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
      child: Column(
        children: [
          // Measurement unit system is a global user preference.
          // Body & Health consumes this value but does not own it.
          AppUnitSystemSelector(
            value: _unitSystem,
            onChanged: _setUnitSystem,
            label: Row(
              children: [
                const AppIcon(
                  icons.AppIcon.systemUnits,
                  size: AppIconSize.small,
                  color: AppIconColor.brand,
                ),
                SizedBox(width: Spacing.of.md),
                const AppText(
                  'Unit System',
                  variant: AppTextVariant.body,
                  color: AppTextColor.primary,
                ),
              ],
            ),
            metricLabel: 'Metric',
            imperialLabel: 'Imperial',
          ),
          const ProfileRowDivider(),
          ProfileSwitchRow(
            icon: CupertinoIcons.bell,
            label: 'Notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              talker.info('Notifications: $value');
            },
          ),
        ],
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
