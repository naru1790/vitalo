import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../../../design/design.dart';

/// HomeScreen
/// Post-login navigation anchor.
/// Identity-first, content-light.
/// Must not evolve into a dashboard.
/// No feature logic or data presentation allowed here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StagePage(
      title: 'Home',
      trailingActions: [
        AppBarIconAction(
          icon: AppIconId.navProfile,
          semanticLabel: 'Profile',
          onPressed: () => context.push(AppRoutes.profile),
        ),
      ],
      hero: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            'Welcome',
            variant: AppTextVariant.title,
            align: TextAlign.center,
          ),
          AppText(
            'Your health companion',
            variant: AppTextVariant.body,
            align: TextAlign.center,
          ),
        ],
      ),
      actions: const SizedBox.shrink(),
    );
  }
}
