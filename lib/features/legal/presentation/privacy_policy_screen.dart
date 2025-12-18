import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Privacy Policy'),
        backgroundColor: surfaceColor,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: Icon(CupertinoIcons.xmark, color: primaryColor),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Privacy Policy', style: AppleTextStyles.title1(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Last updated: December 14, 2025',
                style: AppleTextStyles.captionSecondary(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildSection(
                context,
                'Information We Collect',
                'Vitalo collects information you provide directly, including your health data, '
                    'fitness metrics, and personal preferences to deliver personalized wellness insights.',
              ),
              _buildSection(
                context,
                'How We Use Your Data',
                'Your data is used exclusively to provide and improve your wellness experience. '
                    'We use AI to analyze patterns and provide intelligent recommendations.',
              ),
              _buildSection(
                context,
                'Data Security',
                'We employ industry-standard encryption and security measures to protect your '
                    'personal information. Your health data is stored securely and never sold to third parties.',
              ),
              _buildSection(
                context,
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

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppleTextStyles.headline(context)),
          const SizedBox(height: AppSpacing.sm),
          Text(content, style: AppleTextStyles.body(context)),
        ],
      ),
    );
  }
}
