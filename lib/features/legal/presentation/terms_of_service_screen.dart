import 'package:flutter/widgets.dart';

import '../../../design/design.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return DocumentPage(
      title: 'Terms of Service',
      leadingAction: const AppBarCloseAction(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Terms of Service', variant: AppTextVariant.title),
          SizedBox(height: spacing.sm),
          const AppText(
            'Last updated: December 14, 2025',
            variant: AppTextVariant.caption,
            color: AppTextColor.secondary,
          ),
          SizedBox(height: spacing.xl),
          const AppDocumentSection(
            title: 'Acceptance of Terms',
            content:
                'By accessing and using Vitalo, you accept and agree to be bound by these Terms of Service. '
                'If you do not agree, please do not use our services.',
          ),
          const AppDocumentSection(
            title: 'Service Description',
            content:
                'Vitalo is an AI-powered wellness platform that provides personalized health insights, '
                'fitness tracking, and mental wellness support.',
          ),
          const AppDocumentSection(
            title: 'User Responsibilities',
            content:
                'You are responsible for maintaining the confidentiality of your account and for all '
                'activities under your account. You agree to provide accurate health information.',
          ),
          const AppDocumentSection(
            title: 'Medical Disclaimer',
            content:
                'Vitalo provides wellness insights and is not a substitute for professional medical advice. '
                'Always consult with healthcare professionals for medical decisions.',
          ),
          const AppDocumentSection(
            title: 'Limitation of Liability',
            content:
                'Vitalo is provided "as is" without warranties. We are not liable for any indirect, '
                'incidental, or consequential damages arising from your use of the service.',
          ),
          SizedBox(height: spacing.xxl),
        ],
      ),
    );
  }
}
