import 'package:client/domain/data_handler.dart';
import 'package:client/domain/prefs.dart';
import 'package:client/domain/search_criteria.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'feature_test_functions.dart';
import 'test_functions.dart';

void main() {
  // For RegExp calls, look up documentation for Regex symbols.
  setUp(() async {
    AbstractPrefs.instance = MockPrefs();
    await DataHandler.fetchData(test: true);
  });

  tearDown(() {
    AbstractPrefs.instance = null;
    SearchCriteria.clearInstance();
  });

  testWidgets('Wide: Search Criteria Test', (WidgetTester tester) async {
    await searchCriteriaTest(tester, 2000);
  });

  testWidgets('Wide: Header Card Test', (WidgetTester tester) async {
    await headerCellTest(tester, 2000, numCells: 22);
  });

  testWidgets('Wide: Search by Department', (WidgetTester tester) async {
    await departmentTest(tester, 2000, requirement: equals('CPTR'));
  });

  testWidgets('Wide: Search by Subject', (WidgetTester tester) async {
    await subjectTest(tester, 2000, requirement: equals('AVIA'));
  });

  testWidgets('Wide: Search by Campus', (WidgetTester tester) async {
    await campusTest(tester, 2000, requirement: equals('RO'));
  });

  testWidgets('Wide: Search by Level', (WidgetTester tester) async {
    await levelTest(
      tester,
      2000,
      requirement: contains(RegExp(r'\b5\d{2}\b\w{0,1}\b')),
    );
  });

  testWidgets('Wide: Search by Term', (WidgetTester tester) async {
    await termTest(tester, 2000, requirement: isNot(''));
  });

  testWidgets('Wide: Search by Credits', (WidgetTester tester) async {
    await creditTest(tester, 2000, requirement: equals('3.0'));
  });

  testWidgets('Wide: Search by Day', (WidgetTester tester) async {
    await dayTest(tester, 2000, type: 'Wide');
  });

  testWidgets('Wide: Search by Start Time', (WidgetTester tester) async {
    await startTimeTest(tester, 2000, requirement: contains('10:00AM'));
  });

  testWidgets('Wide: Search by End Time', (WidgetTester tester) async {
    await endTimeTest(tester, 2000, requirement: contains('10:50AM'));
  });

  testWidgets('Wide: Search by Class Number', (WidgetTester tester) async {
    await classNumberTest(tester, 2000);
  });

  testWidgets('Wide: Search by Instructor', (WidgetTester tester) async {
    await instructorTest(tester, 2000, type: 'Wide');
  });

  testWidgets('Wide: Search by Only Open', (WidgetTester tester) async {
    await statusTest(tester, 2000, requirement: equals('Open'), type: 'Wide');
  });

  testWidgets('Wide: Search by Only GS', (WidgetTester tester) async {
    await gsTest(tester, 2000, requirement: equals('GS'), type: 'Wide');
  });

  testWidgets('Wide: Search by Only Not Taken', (WidgetTester tester) async {
    await notTakenClassTest(
      tester,
      2000,
      requirement: equals('notTaken'),
      type: 'Wide',
    );
  });

  testWidgets('Wide: Schedule View Test', (WidgetTester tester) async {
    await scheduleViewTest(tester, 2000, type: 'Wide');
  });

  testWidgets('Wide: Default Sort', (WidgetTester tester) async {
    await defaultSortTest(tester, 2000, type: 'Wide');
  });

  testWidgets('Reset Button', (WidgetTester tester) async {
    await buildTestEnvironment(tester, 2000);
    await openDrawer(tester);
    final Finder resetButton = find.byKey(const Key('Reset Filters Button'));
    expect(resetButton, findsOneWidget);
    final Finder department = find.byKey(const Key('Department Dropdown'));
    expect(department, findsOneWidget);
    final classCount = find.byKey(const Key('Class Found'));
    expect(classCount, findsOneWidget);
    final textWidget = tester.widget<Text>(classCount);
    final text = textWidget.data;
    expect(text, '2370 classes found on .');
  });
}

// await, pump and settle
