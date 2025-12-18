import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

/// Pure Cupertino OTP input without Material dependencies.
/// Optimized for smooth iOS-native experience.
class OtpInput extends StatefulWidget {
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
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());

    // Sync initial value
    if (widget.controller.text.isNotEmpty) {
      _syncFromController();
    }

    widget.controller.addListener(_syncFromController);
    widget.focusNode?.addListener(_onExternalFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromController);
    widget.focusNode?.removeListener(_onExternalFocusChanged);
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onExternalFocusChanged() {
    if (widget.focusNode!.hasFocus && mounted) {
      _focusNodes.first.requestFocus();
    }
  }

  void _syncFromController() {
    if (_isProcessing || !mounted) return;
    final text = widget.controller.text;
    bool changed = false;
    for (int i = 0; i < widget.length; i++) {
      final newValue = i < text.length ? text[i] : '';
      if (_controllers[i].text != newValue) {
        _controllers[i].text = newValue;
        changed = true;
      }
    }
    if (changed) setState(() {});
  }

  void _syncToController() {
    final text = _controllers.map((c) => c.text).join();
    if (widget.controller.text != text) {
      _isProcessing = true;
      widget.controller.text = text;
      _isProcessing = false;
    }
  }

  void _onDigitChanged(int index, String value) {
    if (!widget.enabled) return;

    // Handle paste (multiple digits typed/pasted at once)
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      _fillDigits(digits);
      return;
    }

    // Single digit - advance to next field
    if (value.isNotEmpty) {
      HapticFeedback.selectionClick();
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _syncToController();
    _checkCompletion();
    setState(() {});
  }

  void _fillDigits(String digits) {
    for (int i = 0; i < widget.length && i < digits.length; i++) {
      _controllers[i].text = digits[i];
    }
    _syncToController();

    final nextIndex = digits.length.clamp(0, widget.length - 1);
    if (digits.length >= widget.length) {
      _focusNodes.last.unfocus();
      HapticFeedback.mediumImpact();
    } else {
      _focusNodes[nextIndex].requestFocus();
    }

    _checkCompletion();
    setState(() {});
  }

  void _checkCompletion() {
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      HapticFeedback.selectionClick();
      _syncToController();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _OtpColors.from(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;

        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : AppSpacing.xxs,
            right: index == widget.length - 1 ? 0 : AppSpacing.xxs,
          ),
          child: _DigitBox(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            enabled: widget.enabled,
            hasError: widget.hasError,
            isFilled: isFilled,
            colors: colors,
            isFirst: index == 0,
            onChanged: (v) => _onDigitChanged(index, v),
            onBackspace: () => _onBackspace(index),
          ),
        );
      }),
    );
  }
}

/// Theme colors for OTP boxes
class _OtpColors {
  final Color fill;
  final Color fillActive;
  final Color border;
  final Color borderActive;
  final Color error;
  final Color text;
  final Color cursor;

  const _OtpColors({
    required this.fill,
    required this.fillActive,
    required this.border,
    required this.borderActive,
    required this.error,
    required this.text,
    required this.cursor,
  });

  factory _OtpColors.from(BuildContext context) {
    final primary = VitaloColors.accent.resolveFrom(context);
    return _OtpColors(
      fill: VitaloColors.fillTertiary.resolveFrom(context),
      fillActive: primary.withValues(alpha: 0.12),
      border: VitaloColors.separator.resolveFrom(context),
      borderActive: primary,
      error: VitaloColors.destructive.resolveFrom(context),
      text: VitaloColors.label.resolveFrom(context),
      cursor: primary,
    );
  }
}

/// Single digit input box - optimized for performance
class _DigitBox extends StatelessWidget {
  const _DigitBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasError,
    required this.isFilled,
    required this.colors,
    required this.isFirst,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool hasError;
  final bool isFilled;
  final _OtpColors colors;
  final bool isFirst;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final hasFocus = focusNode.hasFocus;
    final isActive = hasFocus || isFilled;

    return SizedBox(
      width: AppSpacing.touchTargetMin,
      height: AppSpacing.buttonHeight,
      child: CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        maxLength: 2,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofillHints: isFirst ? const [AutofillHints.oneTimeCode] : null,
        showCursor: !isFilled,
        cursorColor: colors.cursor,
        selectionControls: null,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isActive ? colors.fillActive : colors.fill,
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          border: Border.all(
            color: hasError
                ? colors.error
                : isActive
                ? colors.borderActive
                : colors.border,
            width: 1.5,
          ),
        ),
        onChanged: (value) {
          onChanged(value);
          // Handle backspace on empty field
          if (value.isEmpty) {
            onBackspace();
          }
        },
      ),
    );
  }
}
