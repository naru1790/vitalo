import 'package:flutter/cupertino.dart';
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: surfaceColor,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildCompanionHero(context)),
                SliverToBoxAdapter(child: _buildVitalityGrid(context)),
                SliverToBoxAdapter(child: _buildActionSection(context)),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxxl),
                ),
              ],
            ),
          ),
          _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

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
                  style: AppleTextStyles.title3(context),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Ready to crush your goals?',
                  style: AppleTextStyles.callout(
                    context,
                  ).copyWith(color: secondaryLabel),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _buildCoinCounter(context),
          const SizedBox(width: AppSpacing.sm),
          _buildNotificationBell(context),
        ],
      ),
    );
  }

  Widget _buildCoinCounter(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.star_fill,
            color: primaryColor,
            size: AppSpacing.iconSizeSmall,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '250',
            style: AppleTextStyles.footnote(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return Stack(
      children: [
        Container(
          width: AppSpacing.xxxl,
          height: AppSpacing.xxxl,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
            border: Border.all(color: separatorColor, width: 0.5),
          ),
          child: Icon(
            CupertinoIcons.bell,
            color: labelColor,
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
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanionHero(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    // Use a tinted background for the hero card
    final heroBackground = primaryColor.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontalPadding,
        AppSpacing.xl,
        AppSpacing.pageHorizontalPadding,
        AppSpacing.md,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: heroBackground,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: separatorColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 3),
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
                    style: AppleTextStyles.caption1(
                      context,
                    ).copyWith(color: primaryColor, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'You slept great! Let\'s hit 10k steps today and keep that momentum going. 💪',
                    style: AppleTextStyles.callout(
                      context,
                    ).copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalityGrid(BuildContext context) {
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
          Text('Your Vitality', style: AppleTextStyles.title3(context)),
          const SizedBox(height: AppSpacing.md),
          _buildCalorieCard(context),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildStepsCard(context)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildHealthScoreCard(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );

    const eaten = 1450;
    const burned = 2100;
    const progress = eaten / burned;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Calorie Budget', style: AppleTextStyles.headline(context)),
              Icon(
                CupertinoIcons.flame_fill,
                color: primaryColor,
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
                  child: CupertinoActivityIndicator.partiallyRevealed(
                    progress: progress,
                    radius: AppSpacing.cardHeightSmall / 2 - AppSpacing.sm,
                  ),
                ),
                // Custom circular progress
                CustomPaint(
                  size: Size(
                    AppSpacing.cardHeightSmall,
                    AppSpacing.cardHeightSmall,
                  ),
                  painter: _CircularProgressPainter(
                    progress: progress,
                    backgroundColor: tertiaryFill,
                    progressColor: primaryColor,
                    strokeWidth: AppSpacing.sm,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(burned - eaten).toInt()}',
                      style: AppleTextStyles.title2(
                        context,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'cal left',
                      style: AppleTextStyles.caption1(
                        context,
                      ).copyWith(color: secondaryLabel),
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
              _buildCalorieStat(context, 'Eaten', eaten.toString()),
              Container(
                width: 0.5,
                height: AppSpacing.xxl,
                color: separatorColor,
              ),
              _buildCalorieStat(context, 'Burned', burned.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieStat(BuildContext context, String label, String value) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      children: [
        Text(value, style: AppleTextStyles.headline(context)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: AppleTextStyles.caption1(
            context,
          ).copyWith(color: secondaryLabel),
        ),
      ],
    );
  }

  Widget _buildStepsCard(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final accentColor = CupertinoColors.systemGreen.resolveFrom(context);

    const steps = 6842;
    const goal = 10000;
    const progress = steps / goal;

    return Container(
      height: AppSpacing.cardHeightMedium,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CupertinoIcons.person_2_fill,
            color: accentColor,
            size: AppSpacing.xxl,
          ),
          const Spacer(),
          Text(
            steps.toString(),
            style: AppleTextStyles.title2(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Steps',
            style: AppleTextStyles.caption1(
              context,
            ).copyWith(color: secondaryLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xxs),
            child: Container(
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: tertiaryFill,
                borderRadius: BorderRadius.circular(AppSpacing.xxs),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(AppSpacing.xxs),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final errorColor = CupertinoColors.systemRed.resolveFrom(context);

    return Container(
      height: AppSpacing.cardHeightMedium,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CupertinoIcons.heart_fill,
            color: errorColor,
            size: AppSpacing.xxl,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '85',
                style: AppleTextStyles.title2(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.xs,
                  left: AppSpacing.xxs,
                ),
                child: Text(
                  '/100',
                  style: AppleTextStyles.subhead(
                    context,
                  ).copyWith(color: secondaryLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Health Index',
            style: AppleTextStyles.caption1(
              context,
            ).copyWith(color: secondaryLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final accentGreen = CupertinoColors.systemGreen.resolveFrom(context);
    final accentOrange = CupertinoColors.systemOrange.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontalPadding,
          ),
          child: Text(
            'Your Today Plan',
            style: AppleTextStyles.title3(context),
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
                  icon: CupertinoIcons.sportscourt,
                  title: 'Morning Workout',
                  subtitle: '20 min',
                  color: accentGreen,
                ),
                (
                  icon: CupertinoIcons.leaf_arrow_circlepath,
                  title: 'Lunch',
                  subtitle: 'Quinoa Salad',
                  color: primaryColor,
                ),
                (
                  icon: CupertinoIcons.smiley,
                  title: 'Log Mood',
                  subtitle: 'Quick check-in',
                  color: accentOrange,
                ),
              ];
              final item = items[index];
              return _buildActionCard(
                context,
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
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return SizedBox(
      width: AppSpacing.cardHeightMedium,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: separatorColor, width: 0.5),
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
              style: AppleTextStyles.subhead(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: AppleTextStyles.caption1(
                context,
              ).copyWith(color: secondaryLabel),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
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
                CupertinoIcons.house_fill,
                'Home',
                isActive: true,
              ),
              _buildNavItem(context, CupertinoIcons.calendar, 'Plan'),
              _buildNavItemFAB(context),
              _buildNavItem(context, CupertinoIcons.chat_bubble_fill, 'Coach'),
              _buildNavItem(
                context,
                CupertinoIcons.person_fill,
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
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
              color: isActive ? primaryColor : secondaryLabel,
              size: AppSpacing.xl,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: AppleTextStyles.caption2(context).copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? primaryColor : secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemFAB(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return Container(
      width: AppSpacing.xxxl,
      height: AppSpacing.xxxl,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, AppSpacing.xxs),
          ),
        ],
      ),
      child: const Icon(
        CupertinoIcons.qrcode_viewfinder,
        color: CupertinoColors.white,
        size: AppSpacing.xl,
      ),
    );
  }
}

/// Custom circular progress painter for iOS-style calorie tracking
class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -90 * (3.14159 / 180); // Start from top
    final sweepAngle = 2 * 3.14159 * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
