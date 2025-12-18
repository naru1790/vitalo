import 'dart:ui';

import 'package:flutter/cupertino.dart';

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
    showCupertinoModalPopup<String>(
      context: context,
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final isEmpty = _currentText.isEmpty;

    final textStyle = TextStyle(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w600,
      color: isEmpty ? secondaryLabel : labelColor,
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
                CupertinoIcons.pencil,
                size: AppSpacing.md,
                color: isEmpty ? primaryColor : secondaryLabel,
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
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            // Liquid Glass - translucent surface
            color: isDark
                ? surfaceColor.withValues(alpha: 0.85)
                : surfaceColor.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLarge),
            ),
            // Glass edge effect
            border: Border(
              top: BorderSide(
                color: separatorColor.withValues(alpha: 0.2),
                width: LiquidGlass.borderWidth,
              ),
            ),
            // Soft floating shadow
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                bottomPadding + AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: separatorColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  CupertinoTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _save(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    placeholder: widget.placeholder,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: tertiaryFill,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.inputRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: AppSpacing.buttonHeight,
                    child: CupertinoButton.filled(
                      padding: EdgeInsets.zero,
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const CupertinoActivityIndicator(
                              color: CupertinoColors.white,
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
