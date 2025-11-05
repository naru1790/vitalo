import 'package:flutter/material.dart';

class VitaloTextField extends StatefulWidget {
  const VitaloTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.icon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.isPassword = false,
    this.autocorrect,
    this.enableSuggestions,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final Widget? icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool? autocorrect;
  final bool? enableSuggestions;

  @override
  State<VitaloTextField> createState() => _VitaloTextFieldState();
}

class _VitaloTextFieldState extends State<VitaloTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? _obscureText : false,
      autocorrect: widget.autocorrect ?? !widget.isPassword,
      enableSuggestions: widget.enableSuggestions ?? !widget.isPassword,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.icon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                tooltip: _obscureText ? 'Show password' : 'Hide password',
              )
            : null,
      ),
    );
  }
}
