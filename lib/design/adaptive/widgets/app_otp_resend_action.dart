// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-1 semantic control.
// Encodes resend-action affordance and label semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.
//
// IMPORTANT:
// - No timers
// - No countdown lifecycle
// - No business logic
// - No state mutation
// - No styling knobs (no colors/text styles/spacing overrides via API)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_environment_scope.dart';
import '../platform/app_platform_scope.dart';

/// Tier-1 resend OTP action.
///
/// Semantics:
/// - secondsRemaining > 0 => disabled, show countdown label
/// - secondsRemaining == 0 && enabled => enabled, show "Resend code"
///
/// Colors resolved via AppColorScope.
class AppOtpResendAction extends StatelessWidget {
  const AppOtpResendAction({
    super.key,
    required this.secondsRemaining,
    required this.onResend,
    this.enabled = true,
  });

  final int secondsRemaining;
  final VoidCallback onResend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    final colors = AppColorScope.of(context).colors;

    final bool isCountdownActive = secondsRemaining > 0;
    final bool isActionEnabled = enabled && !isCountdownActive;

    // Label semantics are owned here.
    // Feature code must NOT format resend labels.
    final String label = isCountdownActive
        ? 'Resend code in ${secondsRemaining}s'
        : 'Resend code';

    final Color effectiveColor = isActionEnabled
        ? colors.brandPrimary
        : colors.textSecondary;

    // No animation, no haptics.
    // Resend is a calm, secondary action by design.
    if (platform == AppPlatform.ios) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isActionEnabled ? onResend : null,
        child: Text(
          label,
          // Typography intentionally inherits platform defaults.
          // Do NOT introduce custom text styles here.
          style: TextStyle(color: effectiveColor),
        ),
      );
    }

    return TextButton(
      onPressed: isActionEnabled ? onResend : null,
      style: TextButton.styleFrom(foregroundColor: effectiveColor),
      child: Text(
        label,
        // Typography intentionally inherits platform defaults.
        // Do NOT introduce custom text styles here.
      ),
    );
  }
}
