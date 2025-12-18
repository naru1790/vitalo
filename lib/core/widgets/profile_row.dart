// =============================================================================
// PROFILE ROW WIDGETS - iOS 26 Liquid Glass Design
// =============================================================================
// Reusable row components for profile screens and settings.
// Follows Apple Human Interface Guidelines with glass-style cards.
// =============================================================================

import 'package:flutter/cupertino.dart';
import 'package:vitalo/core/theme.dart';

/// Standard tappable row with icon, label, optional value/subtitle, and chevron.
///
/// Use for rows that navigate or open pickers:
/// - Weight, Height, Waist (with value)
/// - Location (with value that may be long)
/// - Health Conditions (with subtitle showing selected items)
/// - Privacy Policy, Terms (no value, just navigation)
class ProfileTappableRow extends StatelessWidget {
  const ProfileTappableRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.subtitle,
    this.iconColor,
    this.labelColor,
    this.onTap,
    this.showChevron = true,
  });

  /// Leading icon
  final IconData icon;

  /// Primary label text
  final String label;

  /// Value shown on the right (e.g., "75 kg", "2000 (25 yrs)")
  /// Shows as muted text if "Not Set" or "—", otherwise primary color
  final String? value;

  /// Secondary line below the label (e.g., "High BP, Diabetes")
  /// Shown in primary color
  final String? subtitle;

  /// Override icon color (default: primary)
  final Color? iconColor;

  /// Override label color (default: onSurface)
  final Color? labelColor;

  /// Tap callback
  final VoidCallback? onTap;

  /// Whether to show chevron (default: true)
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor_ = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final hasValue = value != null && value != 'Not Set' && value != '—';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSpacing.iconSizeSmall,
              color: iconColor ?? primaryColor,
            ),
            const SizedBox(width: AppSpacing.md),

            // Label + optional subtitle
            if (subtitle != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 17,
                        color: labelColor ?? labelColor_,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            else
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  color: labelColor ?? labelColor_,
                ),
              ),

            // Spacer when no subtitle and value needs room
            if (subtitle == null && value != null)
              const SizedBox(width: AppSpacing.md),

            // Value (flexible when no subtitle)
            if (value != null && subtitle == null)
              Expanded(
                child: Text(
                  value!,
                  style: TextStyle(
                    fontSize: 17,
                    color: hasValue ? primaryColor : secondaryLabel,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),

            // Value when subtitle is present (shown as muted on right)
            if (value != null && subtitle != null)
              Text(
                value!,
                style: TextStyle(fontSize: 17, color: secondaryLabel),
              ),

            // Spacer when no value and no subtitle
            if (value == null && subtitle == null) const Spacer(),

            if (showChevron) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                CupertinoIcons.chevron_right,
                size: AppSpacing.iconSizeSmall,
                color: secondaryLabel,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Row with a switch for toggle settings.
///
/// Use for boolean preferences:
/// - Notifications
/// - Health integrations
class ProfileSwitchRow extends StatelessWidget {
  const ProfileSwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.iconColor,
  });

  /// Leading icon
  final IconData icon;

  /// Primary label text
  final String label;

  /// Current switch value
  final bool value;

  /// Called when switch is toggled
  final ValueChanged<bool> onChanged;

  /// Optional subtitle shown below label
  final String? subtitle;

  /// Override icon color (default: primary)
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSizeSmall,
            color: iconColor ?? primaryColor,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: subtitle != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 17, color: labelColor),
                      ),
                      Text(
                        value ? 'Connected' : subtitle!,
                        style: TextStyle(
                          fontSize: 15,
                          color: value ? primaryColor : secondaryLabel,
                        ),
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: TextStyle(fontSize: 17, color: labelColor),
                  ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// iOS-style separator for rows within a card.
/// 0.5px thickness aligned with text after icon.
class ProfileRowDivider extends StatelessWidget {
  const ProfileRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    return Container(
      height: LiquidGlass.borderWidth,
      margin: const EdgeInsets.only(
        left: AppSpacing.md + AppSpacing.iconSizeSmall + AppSpacing.md,
      ),
      color: separatorColor,
    );
  }
}

/// Container for a profile card section.
/// iOS 26 Liquid Glass style with subtle glass edge.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    return Container(
      decoration: BoxDecoration(
        color: tertiaryFill,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: separatorColor.withValues(alpha: 0.3),
          width: LiquidGlass.borderWidth,
        ),
      ),
      child: child,
    );
  }
}
