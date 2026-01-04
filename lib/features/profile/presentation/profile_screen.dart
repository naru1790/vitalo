import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../design/design.dart';
import '../flows/body_measurements_flows.dart';
import '../flows/identity_flows.dart';
import '../flows/personal_info_flows.dart';
import '../models/body_measurements_data.dart';
import '../models/body_measurements_formatter.dart';
import 'sheets/delete_account_confirmation_sheet.dart';
import 'sheets/sign_out_confirmation_sheet.dart';
import 'widgets/profile_body_measurements_section.dart';
import 'widgets/profile_account_section.dart';
import 'widgets/profile_integrations_section.dart';
import 'widgets/profile_personal_info_section.dart';
import 'widgets/profile_preferences_section.dart';

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

    final confirmed = await AppBottomSheet.show<bool>(
      context,
      sheet: const SheetPage(child: SignOutConfirmationSheet()),
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

    final confirmed = await AppBottomSheet.show<bool>(
      context,
      sheet: const SheetPage(child: DeleteAccountConfirmationSheet()),
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

          AppSection(
            title: 'Preferences',
            child: ProfilePreferencesSection(
              unitSystem: _unitSystem,
              onUnitSystemChanged: _setUnitSystem,
              notificationsEnabled: _notificationsEnabled,
              onNotificationsChanged: (value) {
                setState(() => _notificationsEnabled = value);
                talker.info('Notifications: $value');
              },
            ),
          ),

          AppSection(
            title: 'Integrations',
            child: ProfileIntegrationsSection(
              healthConnected: _healthConnected,
              onHealthChanged: (value) {
                setState(() => _healthConnected = value);
                talker.info(
                  'Health Sync: ${value ? 'Connected' : 'Disconnected'}',
                );
              },
            ),
          ),

          AppSection(
            title: 'Account',
            child: ProfileAccountSection(
              onPrivacyPolicyTap: () => context.push(AppRoutes.privacy),
              onTermsTap: () => context.push(AppRoutes.terms),
              onSignOutTap: _handleSignOut,
            ),
          ),

          AppSection(
            child: Center(
              child: AppTappable(
                semanticLabel: 'Delete My Account',
                onPressed: _handleDeleteAccount,
                child: SizedBox(
                  height: Spacing.of.inputHeight,
                  child: const Center(
                    child: AppText(
                      'Delete My Account',
                      variant: AppTextVariant.label,
                      color: AppTextColor.destructive,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
