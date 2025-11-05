import 'package:flutter/material.dart';

class VitaloCard extends StatelessWidget {
  const VitaloCard({
    super.key,
    required this.child,
    this.header,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.backgroundColor,
  });

  final Widget child;
  final Widget? header;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 4,
      margin: margin ?? EdgeInsets.zero,
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: 12),
              Divider(color: Theme.of(context).dividerColor),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );

    return card;
  }
}
