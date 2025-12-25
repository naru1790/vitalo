// @frozen
// Tier-0 adaptive primitive.
// Owns: binary selection interaction.
// Must NOT: expose Widget APIs, styling knobs, or platform checks in feature code.
// Must NOT: override platform selection colors or import AppColorScope.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Tier-0 adaptive binary segmented control.
///
/// The only legal way to render binary toggle selections in feature code.
/// Enforces semantic labels, platform-appropriate interaction, and token-driven styling.
///
/// Feature code MUST use this instead of:
/// - [CupertinoSlidingSegmentedControl]
/// - [SegmentedButton]
/// - [ToggleButtons]
class AppBinarySegmentedControl extends StatelessWidget {
  const AppBinarySegmentedControl({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.onChanged,
  });

  /// Label for the left segment (false state).
  final String leftLabel;

  /// Label for the right segment (true state).
  final String rightLabel;

  /// Current selection. false = left, true = right.
  final bool value;

  /// Called when selection changes.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _IosBinarySegmentedControl(
        leftLabel: leftLabel,
        rightLabel: rightLabel,
        value: value,
        onChanged: onChanged,
      );
    }

    return _AndroidBinarySegmentedControl(
      leftLabel: leftLabel,
      rightLabel: rightLabel,
      value: value,
      onChanged: onChanged,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE — PLATFORM IMPLEMENTATIONS
// ═══════════════════════════════════════════════════════════════════════════

class _IosBinarySegmentedControl extends StatelessWidget {
  const _IosBinarySegmentedControl({
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.onChanged,
  });

  final String leftLabel;
  final String rightLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final textStyles = AppTextStyles.of;

    // Raw Text with typography tokens only.
    // Platform control owns selection color state - we must not override.
    return CupertinoSlidingSegmentedControl<bool>(
      groupValue: value,
      onValueChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      padding: EdgeInsets.all(spacing.xs),
      children: {
        false: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          child: Text(leftLabel, style: textStyles.label),
        ),
        true: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          child: Text(rightLabel, style: textStyles.label),
        ),
      },
    );
  }
}

class _AndroidBinarySegmentedControl extends StatelessWidget {
  const _AndroidBinarySegmentedControl({
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.onChanged,
  });

  final String leftLabel;
  final String rightLabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles.of;

    // Raw Text with typography tokens only.
    // Platform control owns selection color state - we must not override.
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment<bool>(
          value: false,
          label: Text(leftLabel, style: textStyles.label),
        ),
        ButtonSegment<bool>(
          value: true,
          label: Text(rightLabel, style: textStyles.label),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
      showSelectedIcon: false,
    );
  }
}
