// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitalo/features/landing/presentation/landing_screen.dart';

void main() {
  testWidgets('Landing screen displays correctly', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LandingScreen()));

    await tester.pump();

    expect(find.text('Vitalo'), findsOneWidget);
    expect(find.text('Awaken Your Intelligent Wellness'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
