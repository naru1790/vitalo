import 'package:flutter/cupertino.dart';

import '../../../../core/theme.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppleTextStyles.caption1(
              context,
            ).copyWith(color: secondaryLabel, letterSpacing: 1.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: separatorColor, width: 0.5),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Container(
                    height: 0.5,
                    margin: const EdgeInsets.only(left: 72),
                    color: separatorColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
