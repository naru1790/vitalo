import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Vitalo branded checkbox with consistent styling
class VitaloCheckbox extends StatelessWidget {
  const VitaloCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: enabled && onChanged != null
                    ? (newValue) => onChanged!(newValue ?? false)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: label),
          ],
        ),
      ),
    );
  }
}
