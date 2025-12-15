import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/inline_editable_header.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

/// Profile & Settings Screen - Modern 2025 Inline-First UX
/// No dialogs. Everything editable inline or via expanding cards.
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
  String? _dateOfBirth;
  String? _country;

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

  String _formatDateOfBirth() {
    if (_dateOfBirth == null) return 'Not Set';
    final date = DateTime.tryParse(_dateOfBirth!);
    if (date == null) return 'Not Set';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final age = _calculateAge();
    final ageStr = age != null ? ' ($age yrs)' : '';
    return '${date.day} ${months[date.month - 1]} ${date.year}$ageStr';
  }

  int? _calculateAge() {
    if (_dateOfBirth == null) return null;
    final date = DateTime.tryParse(_dateOfBirth!);
    if (date == null) return null;
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  Future<void> _selectDateOfBirth() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final initialDate = _dateOfBirth != null
        ? DateTime.tryParse(_dateOfBirth!) ?? DateTime(now.year - 25)
        : DateTime(now.year - 25);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked.toIso8601String().split('T')[0]);
      talker.info('Date of birth set: $_dateOfBirth');
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
        VitaloSnackBar.showError(context, error);
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
                VitaloSnackBar.showWarning(context, 'Type DELETE to confirm');
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
      VitaloSnackBar.showWarning(context, 'Account deletion coming soon.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible App Bar with Avatar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.background,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(child: _buildHeader(isDark)),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.lg),

                // Personal Info Section
                _buildSectionTitle('Personal Info', isDark),
                const SizedBox(height: AppSpacing.sm),
                _buildPersonalInfoCard(isDark),

                const SizedBox(height: AppSpacing.xl),

                // Body Metrics Section
                _buildSectionTitle('Body Metrics', isDark),
                const SizedBox(height: AppSpacing.sm),
                _buildBodyMetricsCard(isDark),

                const SizedBox(height: AppSpacing.xl),

                // Dietary Preference Section
                _buildSectionTitle('Dietary Preference', isDark),
                const SizedBox(height: AppSpacing.sm),
                _buildDietaryChips(isDark),

                const SizedBox(height: AppSpacing.xl),

                // Preferences Section
                _buildSectionTitle('Preferences', isDark),
                const SizedBox(height: AppSpacing.sm),
                _buildPreferencesCard(isDark),

                const SizedBox(height: AppSpacing.xl),

                // Account Actions
                _buildSectionTitle('Account', isDark),
                const SizedBox(height: AppSpacing.sm),
                _buildAccountCard(isDark),

                const SizedBox(height: AppSpacing.xxl),

                // Delete Account - Subtle at bottom
                Center(
                  child: TextButton(
                    onPressed: _handleDeleteAccount,
                    child: Text(
                      'Delete My Account',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            (isDark
                                    ? AppColors.darkOnSurfaceVariant
                                    : AppColors.onSurfaceVariant)
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Container(
            width: AppSpacing.avatarSizeLarge + AppSpacing.xs,
            height: AppSpacing.avatarSizeLarge + AppSpacing.xs,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                _getDisplayName().isNotEmpty
                    ? _getDisplayName()[0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InlineEditableHeader(
            initialText: _displayName ?? _getDisplayName(),
            onSave: _saveDisplayName,
            placeholder: 'Add your name',
            fontSize: 22, // titleLarge fontSize
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _getUserEmail(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.unit),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: isDark
              ? AppColors.darkOnSurfaceVariant
              : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          // Gender - Inline chips
          _buildChipSelector(
            icon: Icons.wc_outlined,
            label: 'Gender',
            options: const ['Male', 'Female', 'Other'],
            selected: _gender,
            isDark: isDark,
            onSelected: (value) {
              setState(() => _gender = value);
              talker.info('Gender set: $value');
            },
          ),

          _buildDivider(isDark),

          // Date of Birth - Tap to pick
          _buildTappableRow(
            icon: Icons.cake_outlined,
            label: 'Date of Birth',
            value: _formatDateOfBirth(),
            isDark: isDark,
            onTap: _selectDateOfBirth,
          ),

          _buildDivider(isDark),

          // Country - Inline chips
          _buildChipSelector(
            icon: Icons.public_outlined,
            label: 'Country',
            options: const [
              '🇮🇳 India',
              '🇺🇸 US',
              '🇬🇧 UK',
              '🇨🇦 Canada',
              'Other',
            ],
            selected: _country,
            isDark: isDark,
            onSelected: (value) {
              setState(() => _country = value);
              talker.info('Country set: $value');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMetricsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          // Weight - Inline stepper
          _buildStepperRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: _weightKg,
            unit: _isMetric ? 'kg' : 'lbs',
            displayValue: _formatWeight(),
            isDark: isDark,
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

          _buildDivider(isDark),

          // Height - Inline stepper
          _buildStepperRow(
            icon: Icons.height_outlined,
            label: 'Height',
            value: _heightCm,
            unit: _isMetric ? 'cm' : 'ft',
            displayValue: _formatHeight(),
            isDark: isDark,
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

          _buildDivider(isDark),

          // Unit toggle
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
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Unit System',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.onSurface,
                    ),
                  ),
                ),
                _buildSegmentedControl(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryChips(bool isDark) {
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
        color: isDark ? AppColors.darkSurface : AppColors.surface,
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
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.onSurfaceVariant,
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
                    const SizedBox(width: AppSpacing.xs - 2),
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

  Widget _buildPreferencesCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
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
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Notifications',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                ),
              ),
            ),
            Switch.adaptive(
              value: _notificationsEnabled,
              activeTrackColor: isDark
                  ? AppColors.darkPrimary
                  : AppColors.primary,
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

  Widget _buildAccountCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          if (_isGuest()) ...[
            _buildTappableRow(
              icon: Icons.link_rounded,
              label: 'Link Google Account',
              value: 'Save your progress',
              isDark: isDark,
              onTap: () {
                talker.info('Link account tapped');
                // TODO: Implement account linking
              },
            ),
            _buildDivider(isDark),
          ],
          _buildTappableRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.privacy),
          ),
          _buildDivider(isDark),
          _buildTappableRow(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            isDark: isDark,
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            onTap: _handleSignOut,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Reusable Inline Components
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: AppSpacing.huge + AppSpacing.unit, // 52
      color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
    );
  }

  Widget _buildChipSelector({
    required IconData icon,
    required String label,
    required List<String> options,
    required String? selected,
    required bool isDark,
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
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
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
                          vertical: AppSpacing.xs - 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                          ? AppColors.darkOnSurfaceVariant
                                          : AppColors.onSurfaceVariant)
                                      .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: isSelected
                                    ? (isDark
                                          ? AppColors.darkOnPrimary
                                          : AppColors.onPrimary)
                                    : (isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.onSurface),
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
    required bool isDark,
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
          vertical: AppSpacing.sm + AppSpacing.unit,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSpacing.iconSizeSmall,
              color:
                  iconColor ??
                  (isDark ? AppColors.darkPrimary : AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          labelColor ??
                          (isDark
                              ? AppColors.darkOnSurface
                              : AppColors.onSurface),
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: AppSpacing.unit / 2),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: value == 'Not Set'
                            ? (isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.onSurfaceVariant)
                            : (isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSpacing.iconSizeSmall,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.onSurfaceVariant,
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
    required bool isDark,
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
            size: 20,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.onSurface,
                  ),
                ),
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSet
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : (isDark
                              ? AppColors.darkOnSurfaceVariant
                              : AppColors.onSurfaceVariant),
                    fontWeight: isSet ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Stepper controls
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepperButton(
                  icon: Icons.remove,
                  onTap: isSet ? onDecrement : null,
                  isDark: isDark,
                ),
                Container(
                  width: 1,
                  height: AppSpacing.xl,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant.withValues(alpha: 0.2)
                      : AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                ),
                _buildStepperButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                  isDark: isDark,
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
                size: AppSpacing.iconSizeSmall - 2,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
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
    required bool isDark,
  }) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          icon,
          size: AppSpacing.iconSizeSmall - 2,
          color: isDisabled
              ? (isDark
                    ? AppColors.darkOnSurfaceVariant.withValues(alpha: 0.3)
                    : AppColors.onSurfaceVariant.withValues(alpha: 0.3))
              : (isDark ? AppColors.darkPrimary : AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isDark) {
    return SegmentedButton<bool>(
      showSelectedIcon: false,
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
