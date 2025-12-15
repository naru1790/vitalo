import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
                'Terms of Service',
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
                'Acceptance of Terms',
                'By accessing and using Vitalo, you accept and agree to be bound by these Terms of Service. '
                    'If you do not agree, please do not use our services.',
              ),
              _buildSection(
                theme,
                'Service Description',
                'Vitalo is an AI-powered wellness platform that provides personalized health insights, '
                    'fitness tracking, and mental wellness support.',
              ),
              _buildSection(
                theme,
                'User Responsibilities',
                'You are responsible for maintaining the confidentiality of your account and for all '
                    'activities under your account. You agree to provide accurate health information.',
              ),
              _buildSection(
                theme,
                'Medical Disclaimer',
                'Vitalo provides wellness insights and is not a substitute for professional medical advice. '
                    'Always consult with healthcare professionals for medical decisions.',
              ),
              _buildSection(
                theme,
                'Limitation of Liability',
                'Vitalo is provided "as is" without warranties. We are not liable for any indirect, '
                    'incidental, or consequential damages arising from your use of the service.',
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
