// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gui/data_handler.dart';

import 'package:gui/main.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  testWidgets('Dropdown Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Campus Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Department Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Subject Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Term Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Class Number Dropdown')), findsOneWidget);
  });

  testWidgets('Search Criteria does not Overlap with Results',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('Search Criteria Widget')), findsOneWidget);
  });

  testWidgets('Header Button Test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
    // find "Computer Science" and "Communication"
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
    await tester.binding.setSurfaceSize(const Size(2000, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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

    await tester.tap(spring.hitTestable());
    await tester.pumpAndSettle();
    expect(spring.hitTestable(), findsAtLeast(1));
    expect(winter.hitTestable(), findsNothing);
    expect(find.textContaining('Spring'), findsAtLeast(1));
  });

  testWidgets('Default Sort', (WidgetTester tester) async {
    String textInCellWithKey(Element element, String key) {
      final cellRow = element as MultiChildRenderObjectElement;
      final semanticsCell = cellRow.children.firstWhere(
        (element) {
          if (element.widget is Semantics) {
            final semantics = element.widget as Semantics;
            if (semantics.child!.key == Key(key)) {
              return true;
            }
          }
          return false;
        },
      ).widget as Semantics;
      final subjectCell = semanticsCell.child as Container;
      final text = subjectCell.child as Text;
      return text.data!.trim();
    }

    // launch app
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    // select 'Computer Science'
    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    await tester.tap(departmentDropdown);
    await tester.pumpAndSettle();
    final csDepartment = find.text('Computer Science');
    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();

    // verify sort order of subject number
    String prior = '';
    String next = '';
    final itemFinder = find.byKey(const Key('Class'));
    for (final each in itemFinder.evaluate()) {
      final subject = textInCellWithKey(each, 'Subject');
      final summer1 = textInCellWithKey(each, 'Summer1');
      final fall = textInCellWithKey(each, 'Fall');
      final winter = textInCellWithKey(each, 'Winter');
      final spring = textInCellWithKey(each, 'Spring');
      final summer2 = textInCellWithKey(each, 'Summer2');
      final section = textInCellWithKey(each, 'Section');
      final number = '$summer1$fall$winter$spring$summer2';
      late int term;
      if (summer1.isNotEmpty) {
        term = 1;
      } else if (fall.isNotEmpty) {
        term = 2;
      } else if (winter.isNotEmpty) {
        term = 3;
      } else if (spring.isNotEmpty) {
        term = 4;
      } else if (summer2.isNotEmpty) {
        term = 5;
      }
      next = '$subject $number $term $section';
      expect(
        prior.compareTo(next) < 0,
        isTrue,
        reason: 'Sort Failure prior: "$prior" next: "$next".',
      );
      prior = next;
    }
  });
}
