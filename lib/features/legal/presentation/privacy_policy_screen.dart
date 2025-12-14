import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Last updated: December 14, 2025',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildSection(
                theme,
                'Information We Collect',
                'Vitalo collects information you provide directly, including your health data, '
                    'fitness metrics, and personal preferences to deliver personalized wellness insights.',
              ),
              _buildSection(
                theme,
                'How We Use Your Data',
                'Your data is used exclusively to provide and improve your wellness experience. '
                    'We use AI to analyze patterns and provide intelligent recommendations.',
              ),
              _buildSection(
                theme,
                'Data Security',
                'We employ industry-standard encryption and security measures to protect your '
                    'personal information. Your health data is stored securely and never sold to third parties.',
              ),
              _buildSection(
                theme,
                'Your Rights',
                'You have the right to access, modify, or delete your data at any time. '
                    'Contact us at privacy@vitalo.app for any data-related requests.',
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(content, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
