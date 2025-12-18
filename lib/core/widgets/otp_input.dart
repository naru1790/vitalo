import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';

import '../theme.dart';

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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final fillColor = CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final errorColor = CupertinoColors.systemRed.resolveFrom(context);

    final defaultPinTheme = PinTheme(
      width: AppSpacing.touchTargetMin,
      height: AppSpacing.buttonHeight,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: labelColor,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(
          color: hasError ? errorColor : separatorColor,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(color: primaryColor, width: 1.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(color: primaryColor, width: 1.5),
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
      // Enable clipboard paste support
      onClipboardFound: (value) {
        // Auto-paste if clipboard contains valid OTP (digits only, correct length)
        final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length >= length) {
          controller.text = digits.substring(0, length);
          onCompleted?.call(controller.text);
        }
      },
    );
  }
}
