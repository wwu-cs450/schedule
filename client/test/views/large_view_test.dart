import 'package:client/domain/class.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/persister.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../feature_test_functions.dart';
import '../test_functions.dart';

void main() async {
  setUp(() async {
    Term.defaultTermIndex = 2; // 2024-2025
    AbstractPersister.instance = MockPersister();
    WidgetsFlutterBinding.ensureInitialized();
    await Filters().reset(); // Reset filters to defaults
    await Filters().load(); // Load filters from local storage
    await DataHandler.fetchData(test: true); // Fetch class data from server
    Class.instances; // Initialize the class list
    await Filters().update();
  });

  tearDown(() {
    AbstractPersister.instance = null;
    Filters.clearInstance();
  });

  testWidgets('Large: Search Criteria Test', (WidgetTester tester) async {
    await searchCriteriaTest(tester, 2000);
  });

  testWidgets('Large: Header Card Test', (WidgetTester tester) async {
    await headerCellTest(tester, 2000, numCells: 22);
  });

  testWidgets('Large: Search by Department', (WidgetTester tester) async {
    await departmentTest(tester, 2000, requirement: equals('CPTR'));
  });

  testWidgets('Large: Search by Subject', (WidgetTester tester) async {
    await subjectTest(tester, 2000, requirement: equals('AVIA'));
  });

  testWidgets('Large: Search by Campus', (WidgetTester tester) async {
    await campusTest(tester, 2000, requirement: equals('RO'));
  });

  testWidgets('Large: Search by Level', (WidgetTester tester) async {
    await levelTest(
      tester,
      2000,
      requirement: contains(RegExp(r'\b5\d{2}\b\w{0,1}\b')),
    );
  });

  testWidgets('Large: Search by Term', (WidgetTester tester) async {
    await termTest(tester, 2000, requirement: isNot(''));
  });

  testWidgets('Large: Search by Credits', (WidgetTester tester) async {
    await creditTest(tester, 2000, requirement: equals('3.0'));
  });

  testWidgets('Large: Search by Day', (WidgetTester tester) async {
    await dayTest(tester, 2000, type: 'Large');
  });

  testWidgets('Large: Search by Start Time', (WidgetTester tester) async {
    await startTimeTest(tester, 2000, requirement: contains('10:00AM'));
  });

  testWidgets('Large: Search by End Time', (WidgetTester tester) async {
    await endTimeTest(tester, 2000, requirement: contains('10:50AM'));
  });

  testWidgets('Large: Search by Class Number', (WidgetTester tester) async {
    await classNumberTest(tester, 2000);
  });

  testWidgets('Large: Search by Instructor', (WidgetTester tester) async {
    await instructorTest(tester, 2000, type: 'Large');
  });

  testWidgets('Large: Search by Only Open', (WidgetTester tester) async {
    await statusTest(tester, 2000, requirement: equals('Open'), type: 'Large');
  });

  testWidgets('Large: Search by Only GS', (WidgetTester tester) async {
    await gsTest(
      tester,
      2000,
      requirement: equals('General Studies'),
      type: 'Large',
    );
  });

  testWidgets('Large: Search by Only Not Taken', (WidgetTester tester) async {
    await notTakenClassTest(
      tester,
      2000,
      requirement: equals('notTaken'),
      type: 'Large',
    );
  });

  testWidgets('Large: Schedule View Test', (WidgetTester tester) async {
    await scheduleViewTest(tester, 2000, type: 'Large');
  });

  testWidgets('Large: Default Sort', (WidgetTester tester) async {
    await defaultSortTest(tester, 2000, type: 'Large');
  });

  testWidgets('Clear Filters Button', (WidgetTester tester) async {
    await buildTestEnvironment(tester, width: 2000, height: 1500);
    final Finder resetAllButton = find.text('Reset all').hitTestable();
    final Finder classCount = find.byKey(const Key('Class Count'));
    Text textWidget = tester.widget<Text>(classCount);
    expect(textWidget.data, '2370 classes (from 2024-12-13 09:11)');
    expect(resetAllButton, findsNothing);
    expect(classCount, findsOneWidget);

    // Open filter menu
    await openFilterMenu(tester);
    expect(resetAllButton, findsOneWidget);

    // Expand Department section
    final departmentSection = find.text('Department').hitTestable();
    await tester.tap(departmentSection);
    await tester.pumpAndSettle();

    // Scroll to find CPTR if needed
    final scrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );

    if (scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        find.text('CPTR - Computer Science'),
        100,
        scrollable: scrollable.first,
      );
    }

    // Find and tap on CPTR Computer Science
    final cs = find.text('CPTR - Computer Science').hitTestable();
    expect(cs, findsOneWidget);
    await tester.tap(cs);
    await tester.pumpAndSettle();

    // Close filter menu to see results
    await closeFilterMenu(tester);
    await tester.pumpAndSettle();

    textWidget = tester.widget<Text>(classCount);
    expect(textWidget.data, '41 classes (from 2024-12-13 09:11)');

    // Reopen and reset filters
    await openFilterMenu(tester);
    await tester.tap(resetAllButton);
    await tester.pumpAndSettle();
    await closeFilterMenu(tester);
    await tester.pumpAndSettle();

    textWidget = tester.widget<Text>(classCount);
    expect(textWidget.data, '2370 classes (from 2024-12-13 09:11)');
  });
}
