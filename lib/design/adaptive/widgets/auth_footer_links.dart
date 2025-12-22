import 'package:flutter/widgets.dart';

import 'app_button.dart';
import 'app_text.dart';
import '../../tokens/spacing.dart';

/// Footer section displaying legal disclaimer and navigation links.
///
/// Contains:
/// - Disclaimer text ("By continuing, you agree to our")
/// - Terms of Service link
/// - Privacy Policy link
///
/// Uses ghost buttons for visual de-emphasis of legal navigation.
///
/// ## Copy Ownership
///
/// The disclaimer copy is intentionally fixed within this widget to ensure
/// consistent legal language across all authentication entry points.
/// Localization and A/B experimentation are intentionally deferred until
/// legal review establishes approved variants.
///
/// ## Interaction Design
///
/// - [AppButtonVariant.ghost] is intentionally used for legal links.
///   These represent secondary navigation, not primary CTAs.
/// - Full-width buttons are intentional for touch accessibility,
///   providing a larger tap target than inline text links.
// @frozen
class AuthFooterLinks extends StatelessWidget {
  const AuthFooterLinks({
    super.key,
    required this.onTerms,
    required this.onPrivacy,
  });

  /// Called when Terms of Service is tapped.
  final VoidCallback onTerms;

  /// Called when Privacy Policy is tapped.
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Semantics(
      container: true,
      label: 'Legal information',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Footer disclaimer
          const AppText(
            'By continuing, you agree to our',
            variant: AppTextVariant.caption,
            color: AppTextColor.secondary,
            align: TextAlign.center,
          ),

          SizedBox(height: spacing.xs),

          // Terms link — ghost variant for secondary legal navigation
          AppButton(
            label: 'Terms of Service',
            variant: AppButtonVariant.ghost,
            onPressed: onTerms,
          ),

          // Privacy link — ghost variant for secondary legal navigation
          AppButton(
            label: 'Privacy Policy',
            variant: AppButtonVariant.ghost,
            onPressed: onPrivacy,
          ),
        ],
      ),
    );
  }
}
