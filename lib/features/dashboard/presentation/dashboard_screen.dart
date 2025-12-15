import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, colorScheme)),
          SliverToBoxAdapter(child: _buildCompanionHero(context, colorScheme)),
          SliverToBoxAdapter(child: _buildVitalityGrid(context, colorScheme)),
          SliverToBoxAdapter(child: _buildActionSection(context, colorScheme)),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, colorScheme),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.xxxl,
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
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Ready to crush your goals?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _buildCoinCounter(context, colorScheme),
          const SizedBox(width: AppSpacing.sm),
          _buildNotificationBell(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCoinCounter(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            color: colorScheme.primary,
            size: AppSpacing.iconSizeSmall,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '250',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          width: AppSpacing.xxxl,
          height: AppSpacing.xxxl,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
            border: Border.all(color: colorScheme.outline, width: 1),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: colorScheme.onSurface,
            size: AppSpacing.xl,
          ),
        ),
        Positioned(
          right: AppSpacing.xs,
          top: AppSpacing.xs,
          child: Container(
            width: AppSpacing.xs,
            height: AppSpacing.xs,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanionHero(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.xl,
        AppSpacing.pageHorizontalPadding,
        AppSpacing.md,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary, width: 3),
              ),
              child: const Center(
                child: Text('🌟', style: TextStyle(fontSize: AppSpacing.xl)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your AI Companion',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'You slept great! Let\'s hit 10k steps today and keep that momentum going. 💪',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimaryContainer,
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

  Widget _buildVitalityGrid(BuildContext context, ColorScheme colorScheme) {
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCalorieCard(context, colorScheme),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildStepsCard(context, colorScheme)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildHealthScoreCard(context, colorScheme)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard(BuildContext context, ColorScheme colorScheme) {
    const eaten = 1450;
    const burned = 2100;
    const progress = eaten / burned;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calorie Budget',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
              ),
              Icon(
                Icons.local_fire_department_rounded,
                color: colorScheme.primary,
                size: AppSpacing.xl,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: AppSpacing.cardHeightSmall,
            height: AppSpacing.cardHeightSmall,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: AppSpacing.cardHeightSmall,
                  height: AppSpacing.cardHeightSmall,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: AppSpacing.sm,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorScheme.primary,
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
                            color: colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      'cal left',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
              _buildCalorieStat(
                context,
                'Eaten',
                eaten.toString(),
                colorScheme,
              ),
              Container(
                width: 1,
                height: AppSpacing.xxl,
                color: colorScheme.outline,
              ),
              _buildCalorieStat(
                context,
                'Burned',
                burned.toString(),
                colorScheme,
              ),
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
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStepsCard(BuildContext context, ColorScheme colorScheme) {
    const steps = 6842;
    const goal = 10000;
    const progress = steps / goal;

    return Container(
      height: AppSpacing.cardHeightMedium,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.directions_walk_rounded,
            color: colorScheme.tertiary,
            size: AppSpacing.xxl,
          ),
          const Spacer(),
          Text(
            steps.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Steps',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xxs),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSpacing.xs,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: AppSpacing.cardHeightMedium,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: colorScheme.error,
            size: AppSpacing.xxl,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '85',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.xs,
                  left: AppSpacing.xxs,
                ),
                child: Text(
                  '/100',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Health Index',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontalPadding,
          ),
          child: Text(
            'Your Today Plan',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
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
                  color: colorScheme.tertiary,
                ),
                (
                  icon: Icons.restaurant_rounded,
                  title: 'Lunch',
                  subtitle: 'Quinoa Salad',
                  color: colorScheme.primary,
                ),
                (
                  icon: Icons.mood_rounded,
                  title: 'Log Mood',
                  subtitle: 'Quick check-in',
                  color: colorScheme.secondary,
                ),
              ];
              final item = items[index];
              return _buildActionCard(
                context,
                colorScheme,
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
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return SizedBox(
      width: AppSpacing.cardHeightMedium,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: colorScheme.outline, width: 1),
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
              child: Icon(icon, color: color, size: AppSpacing.xl),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
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
                colorScheme,
                Icons.home_rounded,
                'Home',
                isActive: true,
              ),
              _buildNavItem(
                context,
                colorScheme,
                Icons.calendar_today_rounded,
                'Plan',
              ),
              _buildNavItemFAB(context, colorScheme),
              _buildNavItem(
                context,
                colorScheme,
                Icons.chat_bubble_rounded,
                'Coach',
              ),
              _buildNavItem(
                context,
                colorScheme,
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
    ColorScheme colorScheme,
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
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: AppSpacing.xl,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemFAB(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: AppSpacing.xxxl,
      height: AppSpacing.xxxl,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, AppSpacing.xxs),
          ),
        ],
      ),
      child: Icon(
        Icons.qr_code_scanner_rounded,
        color: colorScheme.onPrimary,
        size: AppSpacing.xl,
      ),
    );
  }
}
