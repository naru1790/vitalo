// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-1 compound primitive. Legal footer links for auth screens.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// Legal acknowledgement links for authentication screens.
///
/// Displays:
/// - Disclaimer: "By continuing, you agree to our"
/// - Tappable "Terms of Service" and "Privacy Policy" links with leading icons
///
/// ## Semantic Role
///
/// This component represents **informational acknowledgement** with
/// **lowest interaction priority** on the screen. It must never
/// compete visually with authentication actions.
///
/// ## Design Constraints (NON-NEGOTIABLE)
///
/// - NO buttons, containers, backgrounds, or elevation
/// - NO bold, emphasis, or button affordance
/// - Links rendered as inline tappable text with small leading icon
/// - Caption typography with brand primary color for links
/// - Must visually "fade into the background"
///
/// ## API Lock
///
/// Copy is intentionally hard-coded. Feature code cannot override
/// text or styling. Legal language consistency is mandatory.
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
    final colors = AppColorScope.of(context).colors;

    return Semantics(
      container: true,
      label: 'Legal information',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Disclaimer line — secondary text, lowest emphasis.
          const AppText(
            'By continuing, you agree to our',
            variant: AppTextVariant.caption,
            color: AppTextColor.secondary,
            align: TextAlign.center,
          ),

          // Vertical gap — xs spacing for tight connection.
          SizedBox(height: spacing.xs),

          // Links row — primary color signals interactivity without button affordance.
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(
                text: 'Terms of Service',
                onTap: onTerms,
                colors: colors,
              ),

              // Separator — secondary text, horizontal spacing via gaps.
              SizedBox(width: spacing.xs),
              const AppText(
                '·',
                variant: AppTextVariant.caption,
                color: AppTextColor.secondary,
              ),
              SizedBox(width: spacing.xs),

              _FooterLink(
                text: 'Privacy Policy',
                onTap: onPrivacy,
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INTERNAL LINK COMPONENT
// ═══════════════════════════════════════════════════════════════════════════

/// Internal link widget: [icon] [text] inline.
///
/// Uses text-based interaction (GestureDetector on Row).
/// No button affordance, no background, no container.
/// Brand primary color signals tappability without competing with CTAs.
class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.text,
    required this.onTap,
    required this.colors,
  });

  final String text;
  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    // Intentionally NO motion / press animation here.
    // This is legal acknowledgement (informational, lowest priority), not an action.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Small leading icon — navExternal = external link semantics.
          // Uses xs size for inline link context, brandPrimary for link color.
          AppIcon(
            icons.AppIcon.navExternal,
            size: AppIconSize.xs,
            colorOverride: colors.brandPrimary,
          ),

          // Horizontal gap — xs for tight icon-text connection.
          SizedBox(width: spacing.xs),

          // Link text — uses AppText with link color and underline.
          AppText(
            text,
            variant: AppTextVariant.caption,
            color: AppTextColor.link,
            underline: true,
          ),
        ],
      ),
    );
  }
}
