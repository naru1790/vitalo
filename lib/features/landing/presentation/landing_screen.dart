import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/vitalo_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;

            final content = _LandingContent(isWide: isWide);

            if (isWide) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: content),
                  const Expanded(child: SizedBox()),
                ],
              );
            }

            return Center(child: content);
          },
        ),
      ),
    );
  }
}

class _LandingContent extends StatelessWidget {
  const _LandingContent({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 64 : 32,
      ),
      child: Column(
        crossAxisAlignment: isWide
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isWide
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text('Vitalo', style: textTheme.displayLarge),
                const SizedBox(height: 12),
                Text(
                  'Your AI-Powered Health & Wellness Companion',
                  style: textTheme.bodyLarge,
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (isWide)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VitaloButton(
                        label: 'Get Started',
                        onPressed: () => context.go('/dashboard'),
                      ),
                      const SizedBox(width: 12),
                      VitaloButton(
                        label: 'Sign In',
                        variant: VitaloButtonVariant.secondary,
                        onPressed: () => context.go('/auth/login'),
                      ),
                    ],
                  )
                else ...[
                  VitaloButton(
                    label: 'Get Started',
                    onPressed: () => context.go('/dashboard'),
                    expand: true,
                  ),
                  const SizedBox(height: 12),
                  VitaloButton(
                    label: 'Sign In',
                    variant: VitaloButtonVariant.secondary,
                    onPressed: () => context.go('/auth/login'),
                    expand: true,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Privacy-first. Your data, your control.',
            style: textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
