// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/main.dart';

void main() {
  testWidgets('Search Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Campus Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Department Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Subject Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Term Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Search Button')), findsOneWidget);
  });

  testWidgets('Search Criteria does not Overlap with Results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('Search Criteria Widget')), findsOneWidget);
  });

  testWidgets('Header Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Subject Header Button')), findsOneWidget);
    expect(find.byKey(const Key('Number Header Button')), findsOneWidget);
    expect(find.byKey(const Key('Title Header Button')), findsOneWidget);
  });
}
