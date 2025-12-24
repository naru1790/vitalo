// @adaptive-composite
// Semantics: Inline editable identity text
// Owns: user-triggered edit flow + modal orchestration
// Emits: onSave callback only
// Must NOT:
//  - fetch user data
//  - navigate routes
//  - show global feedback (snackbars, toasts, dialogs)
//  - apply page-level layout or SafeArea

import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';

import '../pages/sheet_page.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_button.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';
import '../widgets/app_text_field.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';

/// Reusable inline editable header - tap to edit in bottom sheet.
///
/// Clean, fixed layout - no inline resizing or shifting.
class InlineEditableHeader extends StatefulWidget {
  const InlineEditableHeader({
    super.key,
    required this.initialText,
    required this.onSave,
    this.placeholder = 'Add text',
  });

  final String initialText;
  final Future<bool> Function(String newText) onSave;
  final String placeholder;

  @override
  State<InlineEditableHeader> createState() => _InlineEditableHeaderState();
}

class _InlineEditableHeaderState extends State<InlineEditableHeader> {
  late String _currentText;

  @override
  void initState() {
    super.initState();
    _currentText = widget.initialText;
  }

  @override
  void didUpdateWidget(InlineEditableHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText) {
      _currentText = widget.initialText;
    }
  }

  void _openEditSheet() {
    AppBottomSheet.show<String>(
      context,
      sheet: SheetPage(
        child: _EditSheetContent(
          initialText: _currentText,
          placeholder: widget.placeholder,
          onSave: widget.onSave,
        ),
      ),
    ).then((result) {
      if (result != null && mounted) {
        setState(() => _currentText = result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final isEmpty = _currentText.isEmpty;
    final displayText = isEmpty ? widget.placeholder : _currentText;

    return GestureDetector(
      onTap: _openEditSheet,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            displayText,
            variant: AppTextVariant.title,
            color: isEmpty ? AppTextColor.secondary : AppTextColor.primary,
          ),
          SizedBox(width: spacing.sm),
          AppIcon(
            icons.AppIcon.actionEdit,
            size: AppIconSize.small,
            color: isEmpty ? AppIconColor.primary : AppIconColor.secondary,
          ),
        ],
      ),
    );
  }
}

/// Pure content for the edit sheet.
///
/// All layout and structure is owned by SheetPage.
/// This widget contains ONLY the form content.
class _EditSheetContent extends StatefulWidget {
  const _EditSheetContent({
    required this.initialText,
    required this.placeholder,
    required this.onSave,
  });

  final String initialText;
  final String placeholder;
  final Future<bool> Function(String) onSave;

  @override
  State<_EditSheetContent> createState() => _EditSheetContentState();
}

class _EditSheetContentState extends State<_EditSheetContent> {
  late TextEditingController _controller;
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
