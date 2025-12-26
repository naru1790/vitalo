import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Personal Info → Birth year picker sheet.
///
/// Stateless UI wrapper that returns the selected year via Navigator.pop.
class BirthYearPickerSheet extends StatelessWidget {
  const BirthYearPickerSheet({super.key, this.initialYear});

  final int? initialYear;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final resolvedInitialYear = initialYear ?? (currentYear - 30);

    return AppYearPickerSheet(
      currentYear: currentYear,
      initialYear: resolvedInitialYear,
    );
  }
}
