import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/persister.dart';
import 'package:client/domain/term.dart';
import 'package:flutter_test/flutter_test.dart';

import '../feature_test_functions.dart';

void main() {
  setUp(() async {
    Term.defaultTermIndex = 2; // 2024-2025
    AbstractPersister.instance = MockPersister();
    await DataHandler.fetchData(test: true);
  });

  tearDown(() {
    AbstractPersister.instance = null;
    Filters.clearInstance();
  });

  testWidgets('Small: Search Criteria Test', (WidgetTester tester) async {
    await searchCriteriaTest(tester, 965);
  });

  testWidgets('Small: Search by Department', (WidgetTester tester) async {
    await departmentTest(tester, 965, requirement: contains('CPTR'));
  });

  testWidgets('Small: Search by Subject', (WidgetTester tester) async {
    await subjectTest(tester, 965, requirement: contains('AVIA'));
  });

  testWidgets('Small: Search by Campus', (WidgetTester tester) async {
    await campusTest(tester, 965, requirement: equals('CMC'));
  });

  testWidgets('Small: Search by Level', (WidgetTester tester) async {
    await levelTest(
      tester,
      965,
      requirement: contains(RegExp(r'\b5\d{2}\b\w{0,1}\b')),
    );
  });

  testWidgets('Small: Search by Term', (WidgetTester tester) async {
    await termTest(tester, 965, requirement: isNot(''));
  });

  testWidgets('Small: Search by Credits', (WidgetTester tester) async {
    await creditTest(tester, 965, requirement: equals('Credits: 3.0'));
  });

  testWidgets('Small: Search by Day', (WidgetTester tester) async {
    await dayTest(tester, 965, type: 'Details');
  });

  testWidgets('Small: Search by Start Time', (WidgetTester tester) async {
    await startTimeTest(tester, 965, requirement: contains('10:00AM'));
  });

  testWidgets('Small: Search by End Time', (WidgetTester tester) async {
    await endTimeTest(tester, 965, requirement: contains('10:50AM'));
  });

  testWidgets('Small: Search by Instructor', (WidgetTester tester) async {
    await instructorTest(tester, 965, type: 'Details');
  });

  testWidgets('Small: Search by Only Open', (WidgetTester tester) async {
    await statusTest(tester, 965, requirement: equals('Open'), type: 'Details');
  });

  testWidgets('Small: Search by Only GS', (WidgetTester tester) async {
    await gsTest(
      tester,
      965,
      requirement: equals('General Studies'),
      type: 'Small',
    );
  });

  testWidgets('Small: Search by Only Not Taken', (WidgetTester tester) async {
    await notTakenClassTest(
      tester,
      965,
      requirement: equals('notTaken'),
      type: 'Small',
    );
  });

  testWidgets('Small: Schedule View Test', (WidgetTester tester) async {
    await scheduleViewTest(tester, 965, type: 'Small');
  });

  testWidgets('Small: Default Sort', (WidgetTester tester) async {
    await defaultSortTest(tester, 965, type: 'Small');
  });
}
