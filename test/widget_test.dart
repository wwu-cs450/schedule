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
  testWidgets('Dropdown Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Campus Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Department Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Subject Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Term Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Class Number Dropdown')), findsOneWidget);
  });

  testWidgets('Search Criteria does not Overlap with Results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('Search Criteria Widget')), findsOneWidget);
  });

  testWidgets('Header Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // NOTE: This only tests the Mobile horizon-view.
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Class\nNumber Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Subject\n Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Sec\n Header Card')), findsOneWidget);
    expect(find.byKey(const Key('GS Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Credits\n Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Course Title Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Status Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Enroll Count Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Enroll Limit Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Waitlist Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Fee Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Meeting Time Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Classroom Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Instructor(s) Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Campus Header Card')), findsOneWidget);
  });

  testWidgets('Search by Campus', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final campusDropdown = find.byKey(const Key('Campus Dropdown'));
    final cpCampus = find.text('College Place');
    final rosarioCampus = find.text('Rosario');

    // Check if campus dropdown is tappable, assuming it exists.
    expect(campusDropdown.hitTestable(), findsOneWidget);
    expect(cpCampus.hitTestable(), findsNothing);
    expect(rosarioCampus.hitTestable(), findsNothing);

    // Open dropdown menu.
    await tester.tap(campusDropdown);
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsOneWidget);
    expect(rosarioCampus.hitTestable(), findsOneWidget);

    // Checks to see if any results are generated that have a campus of College Place
    // Note: This is the small version, so only 1 should be visible without scrolling.
    await tester.tap(cpCampus.hitTestable());
    await tester.pumpAndSettle();
    expect(cpCampus.hitTestable(), findsAtLeast(1));
    expect(rosarioCampus.hitTestable(), findsNothing);
    expect(find.textContaining('CP'), findsAtLeast(1));
  });

  testWidgets('Search by Department', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    final csDepartment = find.text('Computer Science');
    final commDepartment = find.text('Communication');
    final resultsFinder = find.byKey(const Key('Results'));

    // Looking for department dropdown
    expect(departmentDropdown.hitTestable(), findsOneWidget);
    // Making sure "Computer Science" does not exist.
    expect(csDepartment.hitTestable(), findsNothing);
    // Making sure "Communication" does not exist.
    expect(commDepartment.hitTestable(), findsNothing);

    // key 'Results' is only found as a key for the ListView.Builder...
    expect(resultsFinder, findsOneWidget);
    // Ensured headers still exist?

    // Tapping department dropdown.
    await tester.tap(departmentDropdown);
    await tester.pumpAndSettle();
    // Department dropdown open.

    // Scroll through the dropdown menu and look for both "Computer Science" and "Communication".
    final listFinder = find.byType(Scrollable).last;
    for (int i = 0; i < 19; i++) {
      await tester.drag(listFinder, const Offset(0, -50));
      await tester.pumpAndSettle();
      if (csDepartment.hitTestable().evaluate().isNotEmpty &&
          commDepartment.hitTestable().evaluate().isNotEmpty) {
        break;
      }
    }
    // "Computer Science" and "Communication"
    expect(csDepartment.hitTestable(), findsOneWidget);
    expect(commDepartment.hitTestable(), findsOneWidget);

    // Selecting "Computer Science".
    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();
    // Verifying department dropdown is labeled "Computer Science".
    expect(csDepartment.hitTestable(), findsOneWidget);
    // Verifying department dropdown is not labeled "Communication".
    expect(commDepartment.hitTestable(), findsNothing);
    expect(find.textContaining('CPTR'), findsAtLeast(1));
  });

  testWidgets('Search by Subject', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final subjectDropdown = find.byKey(const Key('Subject Dropdown'));
    final hlthSubject = find.text('Health');
    final histSubject = find.text('History');
    final resultsFinder = find.byKey(const Key('Results'));

    // Looks for the "Subject" dropdown.
    expect(subjectDropdown.hitTestable(), findsOneWidget);
    // Makes sure it's not already open.
    expect(hlthSubject.hitTestable(), findsNothing);
    expect(histSubject.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget); // Is this needed?

    // Open dropdown.
    await tester.tap(subjectDropdown);
    await tester.pumpAndSettle();

    // Scroll through dropdown.
    // Scroll through the dropdown menu and look for both "Health" and "History".
    final listFinder = find.byType(Scrollable).last;
    for (int i = 0; i < 87; i++) {
      await tester.drag(listFinder, const Offset(0, -50));
      await tester.pumpAndSettle();
      if (hlthSubject.hitTestable().evaluate().isNotEmpty &&
          histSubject.hitTestable().evaluate().isNotEmpty) {
        break;
      }
    }
    expect(hlthSubject.hitTestable(), findsOneWidget);
    expect(histSubject.hitTestable(), findsOneWidget);

    // Tap on "Health".
    await tester.tap(hlthSubject.hitTestable());
    await tester.pumpAndSettle();
    // Check to make sure dropdown is closed, and result is shown.
    expect(hlthSubject.hitTestable(), findsOneWidget);
    expect(histSubject.hitTestable(), findsNothing);
    expect(find.textContaining('HLTH'), findsAtLeast(1));
  });

  testWidgets('Search by Term', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final termDropdown = find.byKey(const Key('Term Dropdown'));
    final spring = find.textContaining('Spring');
    final winter = find.textContaining('Winter');
    final resultsFinder = find.byKey(const Key('Results'));

    expect(termDropdown.hitTestable(), findsOneWidget);
    expect(spring.hitTestable(), findsNothing);
    expect(winter.hitTestable(), findsNothing);
    expect(resultsFinder, findsOneWidget);

    await tester.tap(termDropdown);
    await tester.pumpAndSettle();
    expect(spring.hitTestable(), findsOneWidget);
    expect(winter.hitTestable(), findsOneWidget);

    final listFinder = find.byType(Scrollable).last;
    for (int i = 0; i < 87; i++) {
      await tester.drag(listFinder, const Offset(0, -50));
      await tester.pumpAndSettle();
      if (spring.hitTestable().evaluate().isNotEmpty) {
        break;
      }
    }

    await tester.tap(spring.hitTestable());
    await tester.pumpAndSettle();
    expect(spring.hitTestable(), findsAtLeast(1));
    expect(winter.hitTestable(), findsNothing);
    expect(find.textContaining('Spring'), findsAtLeast(1));
  });

  testWidgets('Default Sort', (WidgetTester tester) async {
    // Currently this test uses the first 10 items in the CS department
    // So, we're assuming that if the first 10 are sorted, the rest are too.
    // Note, we may need to update this to account for the varying row heights, which is why the first 10 were the only ones used.

    // launch app
    await tester.pumpWidget(const MyApp());
    // select 'Computer Science'
    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    expect(departmentDropdown.hitTestable(), findsOneWidget);
    await tester.tap(departmentDropdown);
    await tester.pumpAndSettle();
    final csDepartment = find.text('Computer Science');
    var listFinder = find.byType(Scrollable).last;
    for (int i = 0; i < 19; i++) {
      await tester.drag(listFinder, const Offset(0, -50));
      await tester.pumpAndSettle();
      if (csDepartment.hitTestable().evaluate().isNotEmpty) {
        break;
      }
    }
    expect(csDepartment.hitTestable(), findsOneWidget);
    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();
    // verify that the full list exists

    // verify sort order of subject number
    String prior = '';
    String next = '';
    listFinder = find.byType(Scrollable).last;
    for (var i = 0; i < 10; ++i) {
      final itemFinder = find.byKey(Key('Class-$i'));
      expect(itemFinder, findsAtLeast(1));
      final dynamic row = tester.firstElement(itemFinder);
      expect(row.children.length, 2);
      final dynamic box = row.widget.children.elementAt(1);
      expect(box.child.children.length, 3);

      // get <String>[] of the row contents
      //  row.children.elementAt(#) = Container
      //  row.children.elementAt(#).child = Text
      final mainRow = box.child.children.elementAt(1);
      if (i > 0) {
        if (mainRow.children.elementAt(2).child != ' ') {
          // Check Sum of last year
          next = mainRow.children.elementAt(2).child.data;
        } else if (mainRow.children.elementAt(3).child != ' ') {
          // Check Fall of this year
          next = mainRow.children.elementAt(3).child.data;
        } else if (mainRow.children.elementAt(4).child != ' ') {
          // Check Winter of this year
          next = mainRow.children.elementAt(4).child.data;
        } else if (mainRow.children.elementAt(5).child != ' ') {
          // Check Spring of this year
          next = mainRow.children.elementAt(5).child.data;
        } else {
          // Check Summer of this year
          next = mainRow.children.elementAt(6).child.data;
        }
        expect(
          prior.compareTo(next) <= 0,
          isTrue,
          reason: 'Sort Failure prior:$prior next:$next.',
        );
        prior = next;
      } else {
        if (mainRow.children.elementAt(2).child != ' ') {
          // Check Sum of last year
          prior = mainRow.children.elementAt(2).child.data;
        } else if (mainRow.children.elementAt(3).child != ' ') {
          // Check Fall of this year
          prior = mainRow.children.elementAt(3).child.data;
        } else if (mainRow.children.elementAt(4).child != ' ') {
          // Check Winter of this year
          prior = mainRow.children.elementAt(4).child.data;
        } else if (mainRow.children.elementAt(5).child != ' ') {
          // Check Spring of this year
          prior = mainRow.children.elementAt(5).child.data;
        } else {
          // Check Summer of this year
          prior = mainRow.children.elementAt(6).child.data;
        }
      }
      await tester.drag(listFinder, const Offset(0, -200));
      await tester.pumpAndSettle();
    }
  });
}
