import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Polished Dashboard Screen - Empathetic Tech Design
/// Material Design 3 + Apple Bento Box aesthetics
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    talker.info('Dashboard screen opened');
  }

  @override
  void dispose() {
    talker.debug('Dashboard screen disposed');
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getFirstName() {
    final user = _authService.currentUser;
    if (user?.email != null) {
      return user!.email!.split('@')[0].split('.')[0];
    }
    return 'Friend';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header with greeting, coins, and notifications
          SliverToBoxAdapter(child: _buildHeader(context, isDark)),

          // Companion Hero Section
          SliverToBoxAdapter(child: _buildCompanionHero(context, isDark)),

          // Vitality Grid
          SliverToBoxAdapter(child: _buildVitalityGrid(context, isDark)),

          // Action Section
          SliverToBoxAdapter(child: _buildActionSection(context, isDark)),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.massive)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, isDark),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.huge,
        AppSpacing.pageHorizontalPadding,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, ${_getFirstName()} 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.unit),
                Text(
                  'Ready to crush your goals?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _buildCoinCounter(context, isDark),
          const SizedBox(width: AppSpacing.sm),
          _buildNotificationBell(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCoinCounter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            size: AppSpacing.iconSizeSmall,
          ),
          const SizedBox(width: AppSpacing.xs - 2),
          Text(
            '250',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context, bool isDark) {
    return Stack(
      children: [
        Container(
          width: AppSpacing.xxxl + AppSpacing.unit,
          height: AppSpacing.xxxl + AppSpacing.unit,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
            border: Border.all(
              color: isDark ? AppColors.darkOutline : AppColors.outline,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            size: AppSpacing.lg + 2,
          ),
        ),
        Positioned(
          right: AppSpacing.xs,
          top: AppSpacing.xs,
          child: Container(
            width: AppSpacing.xs,
            height: AppSpacing.xs,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanionHero(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.xl,
        AppSpacing.pageHorizontalPadding,
        AppSpacing.md,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkPrimaryContainer.withValues(alpha: 0.3),
                    AppColors.darkSecondaryContainer.withValues(alpha: 0.2),
                  ]
                : [
                    AppColors.success.withValues(alpha: 0.15),
                    AppColors.info.withValues(alpha: 0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isDark
                ? AppColors.darkOutline
                : AppColors.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: AppSpacing.avatarSizeLarge,
              height: AppSpacing.avatarSizeLarge,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkPrimary : AppColors.success,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text(
                  '🌟',
                  style: TextStyle(fontSize: AppSpacing.xxl + AppSpacing.unit),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Speech Bubble
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your AI Companion',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'You slept great! Let\'s hit 10k steps today and keep that momentum going. 💪',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.onSurface,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalityGrid(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.xl,
        AppSpacing.pageHorizontalPadding,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Vitality',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Large Card - Calorie Budget
          _buildCalorieCard(context, isDark),
          const SizedBox(height: AppSpacing.md),
          // Two medium cards side by side
          Row(
            children: [
              Expanded(child: _buildStepsCard(context, isDark)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildHealthScoreCard(context, isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard(BuildContext context, bool isDark) {
    const eaten = 1450;
    const burned = 2100;
    const progress = eaten / burned;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calorie Budget',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                ),
              ),
              Icon(
                Icons.local_fire_department_rounded,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: AppSpacing.xxxl * 3 + AppSpacing.lg, // 140
            height: AppSpacing.xxxl * 3 + AppSpacing.lg, // 140
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: AppSpacing.xxxl * 3 + AppSpacing.lg,
                  height: AppSpacing.xxxl * 3 + AppSpacing.lg,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: AppSpacing.sm,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                    color: isDark ? AppColors.darkPrimary : AppColors.success,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(burned - eaten).toInt()}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.onSurface,
                          ),
                    ),
                    Text(
                      'cal left',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalorieStat(context, 'Eaten', eaten.toString(), isDark),
              Container(
                width: 1,
                height: AppSpacing.xxl - 2,
                color: isDark ? AppColors.darkOutline : AppColors.outline,
              ),
              _buildCalorieStat(context, 'Burned', burned.toString(), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieStat(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.unit / 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsCard(BuildContext context, bool isDark) {
    const steps = 6842;
    const goal = 10000;
    const progress = steps / goal;

    return Container(
      height: AppSpacing.xxxl * 4, // 160
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.directions_walk_rounded,
            color: isDark ? AppColors.darkPrimary : AppColors.info,
            size: AppSpacing.xxl - AppSpacing.unit,
          ),
          const Spacer(),
          Text(
            steps.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.unit),
          Text(
            'Steps',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.unit),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSpacing.xs - 2,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              color: isDark ? AppColors.darkPrimary : AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context, bool isDark) {
    return Container(
      height: AppSpacing.xxxl * 4, // 160
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: isDark ? AppColors.darkPrimary : AppColors.error,
            size: AppSpacing.xxl - AppSpacing.unit,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '85',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.xs - 2,
                  left: AppSpacing.unit / 2,
                ),
                child: Text(
                  '/100',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.unit),
          Text(
            'Health Index',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontalPadding,
          ),
          child: Text(
            'Your Today Plan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontalPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final items = [
                (
                  icon: Icons.fitness_center_rounded,
                  title: 'Morning Workout',
                  subtitle: '20 min',
                  color: isDark ? AppColors.darkPrimary : AppColors.success,
                ),
                (
                  icon: Icons.restaurant_rounded,
                  title: 'Lunch',
                  subtitle: 'Quinoa Salad',
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                (
                  icon: Icons.mood_rounded,
                  title: 'Log Mood',
                  subtitle: 'Quick check-in',
                  color: isDark ? AppColors.darkPrimary : AppColors.info,
                ),
              ];
              final item = items[index];
              return _buildActionCard(
                context,
                isDark,
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
                color: item.color,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return SizedBox(
      width: AppSpacing.xxxl * 4, // 160
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.outline,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
              ),
              child: Icon(icon, color: color, size: AppSpacing.lg + 2),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.unit / 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.outline,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                isDark,
                Icons.home_rounded,
                'Home',
                isActive: true,
              ),
              _buildNavItem(
                context,
                isDark,
                Icons.calendar_today_rounded,
                'Plan',
              ),
              _buildNavItemFAB(context, isDark),
              _buildNavItem(
                context,
                isDark,
                Icons.chat_bubble_rounded,
                'Coach',
              ),
              _buildNavItem(
                context,
                isDark,
                Icons.person_rounded,
                'Profile',
                onTap: () {
                  talker.info('Profile tapped from dashboard');
                  context.push(AppRoutes.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    bool isDark,
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant),
              size: AppSpacing.xl + AppSpacing.unit / 2,
            ),
            const SizedBox(height: AppSpacing.unit),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemFAB(BuildContext context, bool isDark) {
    return Container(
      width: AppSpacing.massive,
      height: AppSpacing.massive,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkPrimary, AppColors.darkSecondary]
              : [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                .withValues(alpha: 0.3),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, AppSpacing.unit),
          ),
        ],
      ),
      child: const Icon(
        Icons.qr_code_scanner_rounded,
        color: AppColors.onPrimary,
        size: AppSpacing.xxl - AppSpacing.unit,
      ),
    );
  }
}
