// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule/class.dart';
import 'package:schedule/department.dart';

import 'package:schedule/main.dart';
import 'package:schedule/query.dart';

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

    expect(find.byKey(const Key('Course Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Title Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Term Header Card')), findsOneWidget);
  });

  testWidgets('Search by Campus', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final campusDropdown = find.byKey(const Key('Campus Dropdown'));
    final cpCampus = find.text('College Place');
    final rosarioCampus = find.text('Rosario');
    final searchButton = find.byKey(const Key('Search Button'));

    expect(campusDropdown.hitTestable(), findsOneWidget);
    expect(cpCampus.hitTestable(), findsNothing);
    expect(rosarioCampus.hitTestable(), findsNothing);
    expect(searchButton, findsOneWidget);

    await tester.tap(campusDropdown);
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsOneWidget);
    expect(rosarioCampus.hitTestable(), findsOneWidget);

    await tester.tap(cpCampus.hitTestable());
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsOneWidget);
    expect(rosarioCampus.hitTestable(), findsNothing);
    // This does not include rows.
    expect(find.text('College Place'), findsExactly(2));

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(find.text('College Place'), findsAtLeast(3));
  });

  testWidgets('Search by Department', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    final csDepartment = find.text('Computer Science');
    final commDepartment = find.text('Communication');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));

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
    expect(find.textContaining('CPTR'), findsNothing);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    expect(find.textContaining('CPTR'), findsAtLeast(1));
  });

  testWidgets('Search by Subject', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final subjectDropdown = find.byKey(const Key('Subject Dropdown'));
    final acctSubject = find.text('Accounting');
    final aviationSubject = find.text('Aviation');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));

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
    expect(find.textContaining('ACCT'), findsNothing);

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    expect(find.textContaining('ACCT'), findsAtLeast(1));
  });

  testWidgets('Search by Term', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final termDropdown = find.byKey(const Key('Term Dropdown'));
    final spring2024 = find.text('Spring 2024');
    final summer2024 = find.text('Summer 2024');
    final resultsFinder = find.byKey(const Key('Results'));
    final searchButton = find.byKey(const Key('Search Button'));

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
    // This does not include rows.
    expect(find.text('Spring 2024'), findsExactly(2));

    await tester.tap(searchButton);
    await tester.pumpAndSettle();
    expect(resultsFinder, findsOneWidget);
    expect(find.text('Spring 2024'), findsAtLeast(3));
  });

  testWidgets('Default Sort', (WidgetTester tester) async {
    List<Class> data = <Class>[];
    data = Query(
      department: Department.departmentwithCode('CPTR'),
    ).results().toList();

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
    // verify that the full list exists

    // verify sort order
    String prior = '';
    String next = '';
    for (var i = 1; i < data.length; ++i) {
      final listFinder = find.byType(Scrollable).last;
      final itemFinder = find.byKey(Key('Class-$i'));
      await tester.scrollUntilVisible(
        itemFinder,
        50.0,
        scrollable: listFinder,
      );
      final dynamic row = tester.firstElement(itemFinder);
      expect(row.children.length, 5);
      // get <String>[] of the row contents
      //  row.children.elementAt(1).widget = Card
      //  row.children.elementAt(1).widget.child = SizedBox
      //  row.children.elementAt(1).widget.child.child = Center
      //  row.children.elementAt(1).widget.child.child.child = Text
      //  row.children.elementAt(1).widget.child.child.child.data = String
      if (i > 0) {
        next = row.children.elementAt(1).widget.child.child.child.data;
        expect(
          prior.compareTo(next) <= 0,
          isTrue,
          reason: 'Sort Failure prior:$prior next:$next.',
        );
        prior = next;
      } else {
        prior = row.children.elementAt(1).widget.child.child.child.data;
      }
    }
  });
}
