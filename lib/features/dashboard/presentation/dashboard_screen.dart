import 'package:flutter/material.dart';

import '../../../core/widgets/vitalo_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      _DashboardMetric(title: 'Calories', value: '2,150 kcal'),
      _DashboardMetric(title: 'Sleep', value: '7h 45m'),
      _DashboardMetric(title: 'Mood', value: 'Balanced'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 900
              ? 3
              : constraints.maxWidth > 600
              ? 2
              : 1;

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 4 / 3,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return VitaloCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      metric.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      metric.value,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Coming soon: more insights powered by AI.'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DashboardMetric {
  const _DashboardMetric({required this.title, required this.value});

  final String title;
  final String value;
}
