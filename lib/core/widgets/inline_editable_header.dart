import 'package:flutter/material.dart';

import '../../main.dart';
import '../theme.dart';

/// Reusable inline editable header - tap to edit in bottom sheet.
///
/// Clean, fixed layout - no inline resizing or shifting.
class InlineEditableHeader extends StatefulWidget {
  const InlineEditableHeader({
    super.key,
    required this.initialText,
    required this.onSave,
    this.placeholder = 'Add text',
    this.fontSize = AppSpacing.xl,
  });

  final String initialText;
  final Future<bool> Function(String newText) onSave;
  final String placeholder;
  final double fontSize;

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
    talker.info('Inline header edit sheet opened');
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EditSheet(
        initialText: _currentText,
        placeholder: widget.placeholder,
        onSave: widget.onSave,
      ),
    ).then((result) {
      if (result != null && mounted) {
        setState(() => _currentText = result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEmpty = _currentText.isEmpty;

    final textStyle = textTheme.titleLarge?.copyWith(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w600,
      color: isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
      height: 1.0,
    );

    final displayText = isEmpty ? widget.placeholder : _currentText;

    return GestureDetector(
      onTap: () {
        talker.info('Name tapped - opening edit sheet');
        _openEditSheet();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Text(
              displayText,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Positioned(
              right: -AppSpacing.xl,
              child: Icon(
                Icons.edit_outlined,
                size: AppSpacing.md,
                color: isEmpty
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for editing
class _EditSheet extends StatefulWidget {
  const _EditSheet({
    required this.initialText,
    required this.placeholder,
    required this.onSave,
  });

  final String initialText;
  final String placeholder;
  final Future<bool> Function(String) onSave;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
        talker.info('Header saved successfully');
        Navigator.pop(context, newText);
      } else {
        setState(() => _isSaving = false);
      }
    } catch (e, stack) {
      talker.error('Header save failed', e, stack);
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        bottomPadding + AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: AppSpacing.touchTargetMin,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox(
                      width: AppSpacing.iconSizeSmall,
                      height: AppSpacing.iconSizeSmall,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
