// =============================================================================
// PROFILE ROW WIDGETS - Reusable tappable rows for profile cards
// =============================================================================
// Unified row components used across profile screens and settings.
// Follows Material 3 Soft Minimalistic design.
// =============================================================================

import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasValue = value != null && value != 'Not Set' && value != '—';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
              color: iconColor ?? colorScheme.primary,
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
                      style: textTheme.bodyMedium?.copyWith(
                        color: labelColor ?? colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
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
                style: textTheme.bodyMedium?.copyWith(
                  color: labelColor ?? colorScheme.onSurface,
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
                  style: textTheme.bodyMedium?.copyWith(
                    color: hasValue
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

            // Spacer when no value and no subtitle
            if (value == null && subtitle == null) const Spacer(),

            if (showChevron) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right_rounded,
                size: AppSpacing.iconSizeSmall,
                color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            color: iconColor ?? colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: subtitle != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        value ? 'Connected' : subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: value
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colorScheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Standard divider for separating rows within a card.
///
/// Indented to align with text after icon.
class ProfileRowDivider extends StatelessWidget {
  const ProfileRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppSpacing.md + AppSpacing.iconSizeSmall + AppSpacing.md,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}

/// Container for a profile card section.
///
/// Provides consistent styling for card backgrounds.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: child,
    );
  }
}
