import 'package:flutter/widgets.dart';

import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import 'app_icon.dart';

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
    final typography = AppTextStyles.of;

    // Resolve colors via semantic tokens — no platform widget dependencies.
    final brightness = MediaQuery.platformBrightnessOf(context);
    final colors = AppColorsTokens.resolve(brightness: brightness);

    // Secondary text for disclaimer line.
    final TextStyle disclaimerStyle = typography.caption.copyWith(
      color: colors.textSecondary,
    );

    return Semantics(
      container: true,
      label: 'Legal information',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Disclaimer line — secondary text, lowest emphasis.
          Text(
            'By continuing, you agree to our',
            style: disclaimerStyle,
            textAlign: TextAlign.center,
          ),

          // Vertical gap — xs spacing for tight connection.
          _VerticalGap(spacing.xs),

          // Links row — primary color signals interactivity without button affordance.
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(
                text: 'Terms of Service',
                onTap: onTerms,
                colors: colors,
                typography: typography,
              ),

              // Separator — secondary text, horizontal spacing via gaps.
              _HorizontalGap(spacing.xs),
              Text('·', style: disclaimerStyle),
              _HorizontalGap(spacing.xs),

              _FooterLink(
                text: 'Privacy Policy',
                onTap: onPrivacy,
                colors: colors,
                typography: typography,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INTERNAL SPACING PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════
// These wrap SizedBox to centralize spacing and avoid raw layout primitives
// in the main widget tree. Uses spacing tokens exclusively.
// ═══════════════════════════════════════════════════════════════════════════

class _VerticalGap extends StatelessWidget {
  const _VerticalGap(this.height);
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class _HorizontalGap extends StatelessWidget {
  const _HorizontalGap(this.width);
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
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
    required this.typography,
  });

  final String text;
  final VoidCallback onTap;
  final AppColors colors;
  final AppTypography typography;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    // Brand primary for link color — signals interactivity, remains calm.
    final linkColor = colors.brandPrimary;

    // Caption typography for low emphasis.
    final linkStyle = typography.caption.copyWith(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Small leading icon — navExternal = external link semantics.
          // Uses xs size for inline link context, brandPrimary for link color.
          AppIcon(
            icons.AppIcon.navExternal,
            size: AppIconSize.xs,
            colorOverride: linkColor,
          ),

          // Horizontal gap — xs for tight icon-text connection.
          _HorizontalGap(spacing.xs),

          // Link text.
          Text(text, style: linkStyle),
        ],
      ),
    );
  }
}
