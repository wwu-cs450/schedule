// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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

  testWidgets('Search by Campus', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final campusDropdown = find.byKey(const Key('Campus Dropdown'));
    final cpCampus = find.text('College Place');
    final rosarioCampus = find.text('Rosario');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));
    PaginatedDataTable results = tester.firstWidget(resultsFinder);

    expect(campusDropdown.hitTestable(), findsOneWidget);
    expect(cpCampus.hitTestable(), findsNothing);
    expect(rosarioCampus.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget);
    expect(searchButton, findsOneWidget);

    await tester.tap(campusDropdown);
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsOneWidget);
    expect(rosarioCampus.hitTestable(), findsOneWidget);

    await tester.tap(cpCampus.hitTestable());
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsOneWidget);
    expect(rosarioCampus.hitTestable(), findsNothing);
    expect(results.source.rowCount, 0);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    results = tester.firstWidget(resultsFinder);
    expect(results.source.rowCount > 0, true);
  });

  testWidgets('Search by Department', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    final csDepartment = find.text('Computer Science');
    final commDepartment = find.text('Communication');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));
    PaginatedDataTable results = tester.firstWidget(resultsFinder);

    expect(departmentDropdown.hitTestable(), findsOneWidget);
    expect(csDepartment.hitTestable(), findsNothing);
    expect(commDepartment.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget);
    expect(searchButton, findsOneWidget);

    await tester.tap(departmentDropdown);
    await tester.pumpAndSettle();
    expect(csDepartment.hitTestable(), findsOneWidget);
    expect(commDepartment.hitTestable(), findsOneWidget);

    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();
    expect(csDepartment.hitTestable(), findsOneWidget);
    expect(commDepartment.hitTestable(), findsNothing);
    expect(results.source.rowCount, 0);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    results = tester.firstWidget(resultsFinder);
    expect(results.source.rowCount > 0, true);
  });

  testWidgets('Search by Subject', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final subjectDropdown = find.byKey(const Key('Subject Dropdown'));
    final acctSubject = find.text('Accounting');
    final aviationSubject = find.text('Aviation');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));
    PaginatedDataTable results = tester.firstWidget(resultsFinder);

    expect(subjectDropdown.hitTestable(), findsOneWidget);
    expect(acctSubject.hitTestable(), findsNothing);
    expect(aviationSubject.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget);
    expect(searchButton, findsOneWidget);

    await tester.tap(subjectDropdown);
    await tester.pumpAndSettle();
    expect(acctSubject.hitTestable(), findsOneWidget);
    expect(aviationSubject.hitTestable(), findsOneWidget);

    await tester.tap(acctSubject.hitTestable());
    await tester.pumpAndSettle();
    expect(acctSubject.hitTestable(), findsOneWidget);
    expect(aviationSubject.hitTestable(), findsNothing);
    expect(results.source.rowCount, 0);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    results = tester.firstWidget(resultsFinder);
    expect(results.source.rowCount > 0, true);
  });

  testWidgets('Search by Term', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final termDropdown = find.byKey(const Key('Term Dropdown'));
    final spring2024 = find.text('Spring 2024');
    final summer2024 = find.text('Summer 2024');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));
    PaginatedDataTable results = tester.firstWidget(resultsFinder);

    expect(termDropdown.hitTestable(), findsOneWidget);
    expect(spring2024.hitTestable(), findsNothing);
    expect(summer2024.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget);
    expect(searchButton, findsOneWidget);

    await tester.tap(termDropdown);
    await tester.pumpAndSettle();
    expect(spring2024.hitTestable(), findsOneWidget);
    expect(summer2024.hitTestable(), findsOneWidget);

    await tester.tap(spring2024.hitTestable());
    await tester.pumpAndSettle();
    expect(spring2024.hitTestable(), findsOneWidget);
    expect(summer2024.hitTestable(), findsNothing);
    expect(results.source.rowCount, 0);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    results = tester.firstWidget(resultsFinder);
    expect(results.source.rowCount > 0, true);
  });

  testWidgets('Default Sort', (WidgetTester tester) async {
    // launch app
    await tester.pumpWidget(const MyApp());
    // select 'Computer Science'
    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    expect(departmentDropdown.hitTestable(), findsOneWidget);
    await tester.tap(departmentDropdown);
    await tester.pumpAndSettle();
    final csDepartment = find.text('Computer Science');
    expect(csDepartment.hitTestable(), findsOneWidget);
    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();
    // search
    final searchButton = find.byKey(const Key('Search Button'));
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    // get results
    final resultsFinder = find.byKey(const Key('Results'));
    final PaginatedDataTable results = tester.firstWidget(resultsFinder);
    final dataTableSource = results.source;
    final count = dataTableSource.rowCount;
    expect(
      count > 0,
      isTrue,
      reason: 'Err why are there no rows? widget_test/Default Sort',
    );
    // verify sort order
    String prior = '';
    String next = '';
    for (var i = 0; i < count; ++i) {
      final row = dataTableSource.getRow(i);
      // get <String>[] of the row contents
      final cells = row!.cells.map((e) => (e.child as Text).data).toList();
      expect(
        cells.length,
        3,
        reason:
            'Expected Cell Length Changed add cases in widget_test/Default Sort',
      );
      next = '${cells[0]} ${cells[1]}';
      expect(
        prior.compareTo(next) <= 0,
        isTrue,
        reason: 'Sort Failure prior:$prior next:$next.',
      );
      prior = next;
    }
  });
}
