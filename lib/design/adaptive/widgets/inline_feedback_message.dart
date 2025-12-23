// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0/1 adaptive primitive.
// Standardizes persistent, inline (Level 1) feedback messages.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/widgets.dart';

import '../platform/app_environment_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';
import 'app_icon.dart';
import 'app_text.dart';

/// Inline feedback severity.
///
/// This is Level 1 feedback: persistent, inline, calm.
///
/// Must never escalate to overlays or call [AppErrorFeedback].
enum InlineFeedbackSeverity { error, warning, info, success }

/// Tier-0/1 inline feedback primitive.
///
/// Responsibility boundaries:
/// - Owns icon choice, color semantics, typography role, and spacing.
/// - Renders a quiet inline row: icon + message.
///
/// Layout note:
/// This widget does NOT apply vertical spacing.
/// Parent layouts are responsible for vertical rhythm and separation.
///
/// Contract:
/// InlineFeedbackMessage must never trigger or replace AppErrorFeedback.
/// Escalation to global feedback is owned by feature logic only.
///
/// This widget does NOT:
/// - Trigger global feedback
/// - Animate, dismiss, or time out
/// - Accept styling knobs (no colors, icons, spacing, or text styles)
class InlineFeedbackMessage extends StatelessWidget {
  const InlineFeedbackMessage({
    super.key,
    required this.message,
    required this.severity,
  });

  final String message;
  final InlineFeedbackSeverity severity;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    // NOTE: inline feedback is intentionally token-driven and platform-blind.
    // It must never call AppErrorFeedback or show overlays.
    final colors = AppColorScope.of(context).colors;

    final (icon, color) = _resolveSemantics(colors);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppIcon(icon, size: AppIconSize.xs, colorOverride: color),
        SizedBox(width: spacing.xs),
        Expanded(child: AppText(message, variant: AppTextVariant.caption)),
      ],
    );
  }

  (icons.AppIcon, Color) _resolveSemantics(AppColors colors) {
    return switch (severity) {
      InlineFeedbackSeverity.error => (
        icons.AppIcon.feedbackError,
        colors.feedbackError,
      ),
      InlineFeedbackSeverity.warning => (
        icons.AppIcon.feedbackWarning,
        colors.feedbackWarning,
      ),
      InlineFeedbackSeverity.info => (
        icons.AppIcon.feedbackInfo,
        colors.feedbackInfo,
      ),
      InlineFeedbackSeverity.success => (
        icons.AppIcon.feedbackSuccess,
        colors.feedbackSuccess,
      ),
    };
  }
}
