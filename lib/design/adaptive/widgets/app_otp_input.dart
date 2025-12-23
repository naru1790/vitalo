// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-1 compound adaptive primitive.
// Encodes OTP entry mechanics (focus, layout, completion) behind a
// platform-adaptive, semantic API.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../platform/app_environment_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Tier-1 OTP input primitive.
///
/// Responsibility boundaries:
/// - Owns OTP digit mechanics (per-cell controllers, focus movement, paste)
/// - Owns completion detection (length-based)
/// - Owns layout sizing/spacing via tokens
/// - Owns error visuals ONLY (border/underline)
///
/// This widget does NOT:
/// - Perform verification
/// - Trigger navigation
/// - Manage resend logic/timers
/// - Render error messages (use InlineFeedbackMessage)
/// - Escalate to AppErrorFeedback
///
/// Contract:
/// hasError=true must ONLY affect visuals.
class AppOtpInput extends StatefulWidget {
  const AppOtpInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.enabled = true,
    this.hasError = false,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final bool enabled;
  final bool hasError;
  final FutureOr<void> Function()? onCompleted;

  @override
  State<AppOtpInput> createState() => _AppOtpInputState();
}

class _AppOtpInputState extends State<AppOtpInput> {
  late final List<TextEditingController> _cells;
  late final List<FocusNode> _focusNodes;

  bool _isProcessing = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _cells = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    if (widget.controller.text.isNotEmpty) {
      _syncFromController();
    }

    widget.controller.addListener(_syncFromController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.enabled) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AppOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.enabled && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusNodes.first.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromController);
    for (final controller in _cells) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _syncFromController() {
    if (_isProcessing || !mounted) return;

    final text = widget.controller.text;
    if (text.length < widget.length) {
      _completed = false;
    }

    bool changed = false;
    for (int i = 0; i < widget.length; i++) {
      final newValue = i < text.length ? text[i] : '';
      if (_cells[i].text != newValue) {
        _cells[i].text = newValue;
        changed = true;
      }
    }

    if (changed) setState(() {});
  }

  void _syncToController() {
    final value = _cells.map((c) => c.text).join();
    if (widget.controller.text != value) {
      _isProcessing = true;
      widget.controller.text = value;
      _isProcessing = false;
    }

    if (value.length < widget.length) {
      _completed = false;
    }
  }

  void _checkCompletion() {
    final isComplete = widget.controller.text.length == widget.length;
    if (!isComplete) {
      _completed = false;
      return;
    }

    if (_completed) return;
    _completed = true;

    HapticFeedback.mediumImpact();
    widget.onCompleted?.call();
  }

  void _fillDigits(String digits) {
    for (int i = 0; i < widget.length && i < digits.length; i++) {
      _cells[i].text = digits[i];
    }

    _syncToController();

    final nextIndex = digits.length.clamp(0, widget.length - 1);
    if (digits.length >= widget.length) {
      _focusNodes.last.unfocus();
    } else {
      _focusNodes[nextIndex].requestFocus();
    }

    _checkCompletion();
    setState(() {});
  }

  void _onCellChanged(int index, String value) {
    if (!widget.enabled) return;

    // Handle paste / autofill typing multiple digits at once.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      _fillDigits(digits);
      return;
    }

    if (value.isNotEmpty) {
      HapticFeedback.selectionClick();
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      // Backspace on empty: move back.
      if (index > 0) {
        _cells[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        HapticFeedback.selectionClick();
      }
    }

    _syncToController();
    _checkCompletion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    final colors = AppColorScope.of(context).colors;

    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    final cellSize = spacing.inputHeight;

    final baseBorder = colors.neutralDivider;
    final focusBorder = colors.stateFocus;
    final errorBorder = colors.feedbackError;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (index) {
        final isFilled = _cells[index].text.isNotEmpty;
        final hasFocus = _focusNodes[index].hasFocus;

        final effectiveBorderColor = widget.hasError
            ? errorBorder
            : (hasFocus ? focusBorder : baseBorder);

        final TextStyle digitStyle = AppTextStyles.of.title.copyWith(
          color: colors.textPrimary,
        );

        final Widget field = platform == AppPlatform.ios
            ? CupertinoTextField(
                controller: _cells[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                obscureText: false,
                maxLength: 2,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofillHints: index == 0
                    ? const [AutofillHints.oneTimeCode]
                    : null,
                showCursor: !isFilled,
                cursorColor: colors.brandPrimary,
                style: digitStyle,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: colors.neutralSurface,
                  borderRadius: BorderRadius.circular(shape.md),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: shape.strokeVisible,
                  ),
                ),
                onChanged: (v) => _onCellChanged(index, v),
              )
            : TextField(
                controller: _cells[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: index == widget.length - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                maxLength: 2,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: digitStyle,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (v) => _onCellChanged(index, v),
              );

        final Widget decorated = platform == AppPlatform.android
            ? DecoratedBox(
                decoration: BoxDecoration(
                  // Android: underline-style affordance.
                  border: Border(
                    bottom: BorderSide(
                      color: effectiveBorderColor,
                      width: shape.strokeVisible,
                    ),
                  ),
                ),
                child: field,
              )
            : field;

        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : spacing.xs),
          child: SizedBox(width: cellSize, height: cellSize, child: decorated),
        );
      }),
    );
  }
}
