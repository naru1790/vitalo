import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

// @frozen
// Sheet: Identity → Display Name
// Owns: form UI + local input state
// Emits: edited value via Navigator.pop
// Must NOT: present other modals, access services/repositories, show feedback UI

/// Identity → Display name edit sheet.
///
/// Pure UI: does not present modals and does not access services.
class DisplayNameEditSheet extends StatefulWidget {
  const DisplayNameEditSheet({
    super.key,
    required this.initialText,
    required this.placeholder,
    required this.onSave,
  });

  final String initialText;
  final String placeholder;
  final Future<bool> Function(String newText) onSave;

  @override
  State<DisplayNameEditSheet> createState() => _DisplayNameEditSheetState();
}

class _DisplayNameEditSheetState extends State<DisplayNameEditSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newText = _controller.text.trim();
    if (newText.isEmpty || newText == widget.initialText) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await widget.onSave(newText);
      if (!mounted) return;

      if (success) {
        Navigator.pop(context, newText);
      } else {
        setState(() => _isSaving = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _controller,
          placeholder: widget.placeholder,
          textInputAction: TextInputAction.done,
          onSubmitted: _save,
        ),
        SizedBox(height: spacing.md),
        AppButton(
          label: 'Save',
          variant: AppButtonVariant.primary,
          onPressed: _save,
          loading: _isSaving,
          enabled: !_isSaving,
        ),
      ],
    );
  }
}
