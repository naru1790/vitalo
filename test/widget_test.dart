// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitalo/main.dart';

void main() {
  testWidgets('Landing screen presents premium onboarding', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VitaloApp()));

    await tester.pump();

    expect(find.text('Vitalo'), findsOneWidget);
    expect(find.text('Daily rituals for enduring vitality.'), findsOneWidget);
    expect(find.text('Initiate My Vital Plan'), findsOneWidget);
    expect(find.text('I Already Have Momentum'), findsOneWidget);

    await tester.tap(find.text('Initiate My Vital Plan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
