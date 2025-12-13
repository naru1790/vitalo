import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.enabled = true,
    this.hasError = false,
    this.onCompleted,
    this.length = 6,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String>? onCompleted;
  final int length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? colorScheme.error : colorScheme.outline,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary, width: 1.5),
      ),
    );

    return Pinput(
      controller: controller,
      focusNode: focusNode,
      length: length,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      enabled: enabled,
      onCompleted: onCompleted,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}
