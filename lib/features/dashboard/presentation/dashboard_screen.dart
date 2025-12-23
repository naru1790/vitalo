import 'package:flutter/widgets.dart';

import '../../../design/design.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      safeArea: AppSafeArea.all,
      backgroundSurface: AppBackgroundSurface.base,
      body: AppPageBody(
        scroll: AppPageScroll.never,
        child: Center(
          child: AppText(
            'Dashboard',
            variant: AppTextVariant.title,
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
