// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import 'app_icon.dart';

/// Tier-0 adaptive text field primitive.
///
/// Feature code MUST use this instead of [CupertinoTextField] or [TextField].
///
/// Responsibility boundaries:
/// - Owns padding/height/radius/background/border/error/disabled visuals
/// - Performs platform branching internally via [AppPlatformScope]
/// - Exposes only semantic intent (placeholder, leading icon, error text)
///
/// This widget does NOT:
/// - Perform validation
/// - Manage form submission flows
/// - Expose styling knobs
/// - Render error messages (only error visuals)
///
/// Error message rendering is owned by feature layouts (e.g., an inline
/// feedback widget). AppTextField only reflects error state via visuals.
///
/// DO NOT:
/// - Add validation behavior
/// - Add appearance knobs (fillColor, borderRadius, etc.)
/// - Add platform branching outside this file
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.placeholder,
    this.leadingIcon,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.errorText,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final icons.AppIcon? leadingIcon;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  /// Drives error visuals only.
  ///
  /// This value is used to toggle error styling (e.g., border color) but this
  /// widget does NOT render error messages; error message rendering is owned by
  /// feature layouts.
  final String? errorText;

  /// Called when the user submits from the keyboard.
  final VoidCallback? onSubmitted;

  final ValueChanged<String>? onChanged;

  bool get _hasError => (errorText != null && errorText!.isNotEmpty);

  void _handleKeyboardSubmit() {
    onSubmitted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _CupertinoTextFieldImpl(
        controller: controller,
        focusNode: focusNode,
        placeholder: placeholder,
        leadingIcon: leadingIcon,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        hasError: _hasError,
        onChanged: onChanged,
        onSubmitted: _handleKeyboardSubmit,
      );
    }

    return _MaterialTextFieldImpl(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      leadingIcon: leadingIcon,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      hasError: _hasError,
      onChanged: onChanged,
      onSubmitted: _handleKeyboardSubmit,
    );
  }
}

class _FieldDecoration {
  const _FieldDecoration({
    required this.background,
    required this.borderColor,
    required this.borderWidth,
    required this.textColor,
    required this.placeholderColor,
    required this.iconColor,
  });

  final Color background;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final Color placeholderColor;
  final Color iconColor;
}

_FieldDecoration _resolveDecoration({
  required AppColors colors,
  required bool enabled,
  required bool hasError,
  required AppShape shape,
}) {
  if (!enabled) {
    return _FieldDecoration(
      background: colors.stateDisabled,
      borderColor: colors.neutralDivider,
      borderWidth: shape.strokeSubtle,
      textColor: colors.textSecondary,
      placeholderColor: colors.textTertiary,
      iconColor: colors.textSecondary,
    );
  }

  if (hasError) {
    return _FieldDecoration(
      background: colors.neutralSurface,
      borderColor: colors.feedbackError,
      borderWidth: shape.strokeVisible,
      textColor: colors.textPrimary,
      placeholderColor: colors.textTertiary,
      iconColor: colors.textSecondary,
    );
  }

  return _FieldDecoration(
    background: colors.neutralSurface,
    borderColor: colors.neutralDivider,
    borderWidth: shape.strokeSubtle,
    textColor: colors.textPrimary,
    placeholderColor: colors.textTertiary,
    iconColor: colors.textSecondary,
  );
}

class _CupertinoTextFieldImpl extends StatelessWidget {
  const _CupertinoTextFieldImpl({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.leadingIcon,
    required this.enabled,
    required this.obscureText,
    required this.keyboardType,
    required this.textInputAction,
    required this.hasError,
    required this.onSubmitted,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final icons.AppIcon? leadingIcon;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool hasError;
  final VoidCallback onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    final AppColors colors = AppColorScope.of(context).colors;

    final decoration = _resolveDecoration(
      colors: colors,
      enabled: enabled,
      hasError: hasError,
      shape: shape,
    );

    return SizedBox(
      height: spacing.inputHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: decoration.background,
          borderRadius: BorderRadius.circular(shape.md),
          border: Border.all(
            color: decoration.borderColor,
            width: decoration.borderWidth,
          ),
        ),
        child: CupertinoTextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          placeholder: placeholder,
          style: AppTextStyles.of.body.copyWith(color: decoration.textColor),
          placeholderStyle: AppTextStyles.of.body.copyWith(
            color: decoration.placeholderColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          prefix: leadingIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: spacing.md),
                  child: AppIcon(
                    leadingIcon!,
                    size: AppIconSize.small,
                    colorOverride: decoration.iconColor,
                  ),
                ),
          decoration: null,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted(),
        ),
      ),
    );
  }
}

class _MaterialTextFieldImpl extends StatelessWidget {
  const _MaterialTextFieldImpl({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.leadingIcon,
    required this.enabled,
    required this.obscureText,
    required this.keyboardType,
    required this.textInputAction,
    required this.hasError,
    required this.onSubmitted,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final icons.AppIcon? leadingIcon;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool hasError;
  final VoidCallback onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    final AppColors colors = AppColorScope.of(context).colors;

    final decoration = _resolveDecoration(
      colors: colors,
      enabled: enabled,
      hasError: hasError,
      shape: shape,
    );

    return SizedBox(
      height: spacing.inputHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: decoration.background,
          borderRadius: BorderRadius.circular(shape.md),
          border: Border.all(
            color: decoration.borderColor,
            width: decoration.borderWidth,
          ),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              SizedBox(width: spacing.md),
              AppIcon(
                leadingIcon!,
                size: AppIconSize.small,
                colorOverride: decoration.iconColor,
              ),
              SizedBox(width: spacing.sm),
            ] else
              SizedBox(width: spacing.md),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                obscureText: obscureText,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: AppTextStyles.of.body.copyWith(
                  color: decoration.textColor,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: placeholder,
                  hintStyle: AppTextStyles.of.body.copyWith(
                    color: decoration.placeholderColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: spacing.sm),
                ),
                onChanged: onChanged,
                onSubmitted: (_) => onSubmitted(),
              ),
            ),
            SizedBox(width: spacing.md),
          ],
        ),
      ),
    );
  }
}
