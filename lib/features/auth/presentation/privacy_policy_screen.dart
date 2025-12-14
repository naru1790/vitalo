import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../core/theme/app_spacing.dart';

/// Privacy Policy screen
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    talker.info('Privacy Policy screen opened');
  }

  @override
  void dispose() {
    talker.debug('Privacy Policy screen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vitalo Privacy Policy',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Last updated: December 10, 2025',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            _buildSection(
              context,
              'Your Privacy Matters',
              'At Vitalo, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
            ),

            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information that you provide directly to us, including:\n\n• Account information (email, name)\n• Health and wellness data you choose to share\n• Usage data and analytics\n• Device information and identifiers\n• Location data (with your permission)',
            ),

            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve our Service\n• Personalize your wellness experience\n• Send you updates and notifications\n• Analyze usage patterns and trends\n• Protect against fraud and abuse\n• Comply with legal obligations',
            ),

            _buildSection(
              context,
              '3. Data Security',
              'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. This includes:\n\n• Encryption of data in transit and at rest\n• Regular security assessments\n• Limited access to personal information\n• Secure authentication mechanisms',
            ),

            _buildSection(
              context,
              '4. Health Information',
              'Your health and wellness data is particularly sensitive. We:\n\n• Never sell your health information\n• Only share health data with your explicit consent\n• Use industry-standard security practices\n• Comply with applicable health privacy laws\n• Allow you to export or delete your data',
            ),

            _buildSection(
              context,
              '5. Third-Party Services',
              'We may use third-party service providers to help us operate our Service. These providers have access to your information only to perform specific tasks on our behalf and are obligated to protect your information.',
            ),

            _buildSection(
              context,
              '6. Your Rights and Choices',
              'You have the right to:\n\n• Access your personal information\n• Correct inaccurate data\n• Request deletion of your data\n• Opt-out of marketing communications\n• Withdraw consent for data processing\n• Export your data in a portable format',
            ),

            _buildSection(
              context,
              '7. Data Retention',
              'We retain your personal information for as long as necessary to provide our Service and fulfill the purposes described in this Privacy Policy, unless a longer retention period is required by law.',
            ),

            _buildSection(
              context,
              '8. Children\'s Privacy',
              'Our Service is not intended for children under 18 years of age. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),

            _buildSection(
              context,
              '9. International Data Transfers',
              'Your information may be transferred to and maintained on servers located outside of your state, province, country, or other governmental jurisdiction where data protection laws may differ.',
            ),

            _buildSection(
              context,
              '10. Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
            ),

            _buildSection(
              context,
              '11. Contact Us',
              'If you have any questions about this Privacy Policy or our data practices, please contact us at:\n\nprivacy@vitalo.app\n\nVitalo, Inc.\n[Your Address]\n[City, State, ZIP]',
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
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
