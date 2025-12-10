import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Vitalo branded text field with consistent styling
class VitaloTextField extends StatefulWidget {
  const VitaloTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.autocorrect,
    this.enableSuggestions,
    this.maxLines = 1,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final int maxLines;
  final bool enabled;

  @override
  State<VitaloTextField> createState() => _VitaloTextFieldState();
}

class _VitaloTextFieldState extends State<VitaloTextField> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect ?? !widget.obscureText,
      enableSuggestions: widget.enableSuggestions ?? !widget.obscureText,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      enabled: widget.enabled,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface.withOpacity(0.4),
        ),
        helperText: widget.helperText,
        helperStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: AppSpacing.iconSize,
                color: colorScheme.onSurface.withOpacity(0.6),
              )
            : null,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
