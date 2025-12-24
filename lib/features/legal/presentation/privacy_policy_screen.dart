import 'package:flutter/widgets.dart';

import '../../../design/design.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return DocumentPage(
      title: 'Privacy Policy',
      leadingAction: const AppBarCloseAction(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Privacy Policy', variant: AppTextVariant.title),
          SizedBox(height: spacing.sm),
          const AppText(
            'Last updated: December 14, 2025',
            variant: AppTextVariant.caption,
            color: AppTextColor.secondary,
          ),
          SizedBox(height: spacing.xl),
          const AppDocumentSection(
            title: 'Information We Collect',
            content:
                'Vitalo collects information you provide directly, including your health data, '
                'fitness metrics, and personal preferences to deliver personalized wellness insights.',
          ),
          const AppDocumentSection(
            title: 'How We Use Your Data',
            content:
                'Your data is used exclusively to provide and improve your wellness experience. '
                'We use AI to analyze patterns and provide intelligent recommendations.',
          ),
          const AppDocumentSection(
            title: 'Data Security',
            content:
                'We employ industry-standard encryption and security measures to protect your '
                'personal information. Your health data is stored securely and never sold to third parties.',
          ),
          const AppDocumentSection(
            title: 'Your Rights',
            content:
                'You have the right to access, modify, or delete your data at any time. '
                'Contact us at privacy@vitalo.app for any data-related requests.',
          ),
          SizedBox(height: spacing.xxl),
        ],
      ),
    );
  }
}
