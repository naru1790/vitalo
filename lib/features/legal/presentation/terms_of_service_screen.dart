import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Terms of Service'),
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
              Text('Terms of Service', style: AppleTextStyles.title1(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Last updated: December 14, 2025',
                style: AppleTextStyles.captionSecondary(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildSection(
                context,
                'Acceptance of Terms',
                'By accessing and using Vitalo, you accept and agree to be bound by these Terms of Service. '
                    'If you do not agree, please do not use our services.',
              ),
              _buildSection(
                context,
                'Service Description',
                'Vitalo is an AI-powered wellness platform that provides personalized health insights, '
                    'fitness tracking, and mental wellness support.',
              ),
              _buildSection(
                context,
                'User Responsibilities',
                'You are responsible for maintaining the confidentiality of your account and for all '
                    'activities under your account. You agree to provide accurate health information.',
              ),
              _buildSection(
                context,
                'Medical Disclaimer',
                'Vitalo provides wellness insights and is not a substitute for professional medical advice. '
                    'Always consult with healthcare professionals for medical decisions.',
              ),
              _buildSection(
                context,
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
