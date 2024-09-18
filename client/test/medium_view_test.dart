import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import 'feature_test_functions.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  testWidgets('Medium: Search Criteria Test', (WidgetTester tester) async {
    await searchCriteriaTest(tester, 970);
  });

  testWidgets('Medium: Header Card Test', (WidgetTester tester) async {
    await headerCellTest(tester, 970, numCells: 14);
  });

  testWidgets('Medium: Search by Department', (WidgetTester tester) async {
    await departmentTest(tester, 970, requirement: contains('CPTR'));
  });

  testWidgets('Medium: Search by Subject', (WidgetTester tester) async {
    await subjectTest(tester, 970, requirement: contains('AVIA'));
  });

  testWidgets('Medium: Search by Campus', (WidgetTester tester) async {
    await campusTest(tester, 970, requirement: equals('RO'));
  });

  testWidgets('Medium: Search by Level', (WidgetTester tester) async {
    await levelTest(
      tester,
      970,
      requirement: contains(RegExp(r'\b5\d{2}\b\w{0,1}\b')),
    );
  });

  testWidgets('Medium: Search by Term', (WidgetTester tester) async {
    await termTest(tester, 970, requirement: isNot(''));
  });

  testWidgets('Medium: Search by Credits', (WidgetTester tester) async {
    await creditTest(tester, 970, requirement: equals('3.0'));
  });

  testWidgets('Medium: Search by Day', (WidgetTester tester) async {
    await dayTest(tester, 970, type: 'Medium');
  });

  testWidgets('Medium: Search by Start Time', (WidgetTester tester) async {
    await startTimeTest(tester, 970, requirement: contains('10:00AM'));
  });

  testWidgets('Medium: Search by End Time', (WidgetTester tester) async {
    await endTimeTest(tester, 970, requirement: contains('10:50AM'));
  });

  testWidgets('Medium: Search by Class Number', (WidgetTester tester) async {
    await classNumberTest(tester, 970);
  });

  testWidgets('Medium: Search by Instructor', (WidgetTester tester) async {
    await instructorTest(tester, 970, type: 'Medium');
  });

  testWidgets('Medium: Search by Only Open', (WidgetTester tester) async {
    await statusTest(tester, 970, requirement: equals('Open'), type: 'Medium');
  });

  testWidgets('Medium: Search by Only GS', (WidgetTester tester) async {
    await gsTest(tester, 970, requirement: equals('GS'), type: 'Medium');
  });

  testWidgets('Medium: Schedule View Test', (WidgetTester tester) async {
    await scheduleViewTest(tester, 970, type: 'Medium');
  });

  testWidgets('Medium: Default Sort', (WidgetTester tester) async {
    await defaultSortTest(tester, 970, type: 'Medium');
  });

  testWidgets('Medium: Check for Correct Term Visual',
      (WidgetTester tester) async {
    await mediumTermTest(tester);
  });
}
