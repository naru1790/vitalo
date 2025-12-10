import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// Terms of Service screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vitalo Terms of Service',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Last updated: December 10, 2025',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            _buildSection(
              context,
              'Welcome to Vitalo',
              'These Terms of Service ("Terms") govern your access to and use of Vitalo\'s mobile application, website, and related services (collectively, the "Service"). By accessing or using our Service, you agree to be bound by these Terms.',
            ),

            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By creating an account and using Vitalo, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms, please do not use our Service.',
            ),

            _buildSection(
              context,
              '2. Description of Service',
              'Vitalo is an intelligent wellness platform that learns and grows with you. Our Service provides personalized health insights, wellness tracking, and recommendations to support your physical, nutritional, and mental well-being.',
            ),

            _buildSection(
              context,
              '3. User Accounts',
              'To use certain features of our Service, you must create an account. You are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n\nYou must be at least 18 years old to create an account.',
            ),

            _buildSection(
              context,
              '4. Health Information Disclaimer',
              'Vitalo provides general wellness information and is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.',
            ),

            _buildSection(
              context,
              '5. User Conduct',
              'You agree not to:\n\n• Use the Service for any illegal purpose\n• Violate any laws in your jurisdiction\n• Infringe on the intellectual property rights of others\n• Transmit harmful code or viruses\n• Attempt to gain unauthorized access to our systems',
            ),

            _buildSection(
              context,
              '6. Intellectual Property',
              'All content, features, and functionality of the Service are owned by Vitalo and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
            ),

            _buildSection(
              context,
              '7. Termination',
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason, including if you breach these Terms. Upon termination, your right to use the Service will cease immediately.',
            ),

            _buildSection(
              context,
              '8. Limitation of Liability',
              'To the maximum extent permitted by law, Vitalo shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the Service.',
            ),

            _buildSection(
              context,
              '9. Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms on this page and updating the "Last updated" date. Your continued use of the Service after changes constitutes acceptance of the new Terms.',
            ),

            _buildSection(
              context,
              '10. Contact Us',
              'If you have any questions about these Terms, please contact us at:\n\nsupport@vitalo.app',
            ),

            const SizedBox(height: AppSpacing.giant),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
