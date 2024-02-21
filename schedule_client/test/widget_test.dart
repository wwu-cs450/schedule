// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/data_handler.dart';

import 'package:schedule_client/main.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  testWidgets('Dropdown Button Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Department Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Subject Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Campus Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Level Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Term Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Credits Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('Start Time Dropdown')), findsOneWidget);
    expect(find.byKey(const Key('End Time Dropdown')), findsOneWidget);
  });

  testWidgets('Search Criteria does not Overlap with Results',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('Search Criteria Widget')), findsOneWidget);
  });

  testWidgets('Header Button Test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('Class# Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Subject Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Sec Header Card')), findsOneWidget);
    expect(find.byKey(const Key('GS Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Cr Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Course Title Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Status Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Enroll\nCount Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Enroll\nLimit Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Waitlist Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Fee Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Meeting Time Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Classroom Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Instructor(s) Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Campus Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Video Header Card')), findsOneWidget);
    expect(find.byKey(const Key('Consent Header Card')), findsOneWidget);
  });

  testWidgets('Search by Department', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final departmentDropdown = find.byKey(const Key('Department Dropdown'));
    final csDepartment = find.text('CPTR Computer Science');
    final commDepartment = find.text('COMM Communication');
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
    final hlthSubject = find.text('HLTH Health');
    final histSubject = find.text('HIST History');
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

  testWidgets('Search by Campus', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final campusDropdown = find.byKey(const Key('Campus Dropdown'));
    final cpCampus = find.text('CP College Place');
    final rosarioCampus = find.text('RO Rosario');

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

  testWidgets('Search by Level', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final levelDropdown = find.byKey(const Key('Level Dropdown'));
    final any = find.text('Any');
    final lower = find.text('Lower');
    final upper = find.text('Upper');
    final grad = find.text('Grad');

    expect(levelDropdown.hitTestable(), findsOneWidget);
    expect(any.hitTestable(), findsNothing);
    expect(lower.hitTestable(), findsNothing);
    expect(upper.hitTestable(), findsNothing);
    expect(grad.hitTestable(), findsNothing);

    await tester.tap(levelDropdown);
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsOneWidget);
    expect(lower.hitTestable(), findsOneWidget);
    expect(upper.hitTestable(), findsOneWidget);
    expect(grad.hitTestable(), findsOneWidget);

    await tester.tap(lower.hitTestable());
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsNothing);
    expect(lower.hitTestable(), findsAtLeast(1));
    expect(upper.hitTestable(), findsNothing);
    expect(grad.hitTestable(), findsNothing);

    // Explained RegExp string:
    // \b - word boundary
    // 2\d{2} - 2 followed by any 2 digits
    // \w{0,1} - 0 or 1 of any character
    expect(
      find.textContaining(RegExp(r'\b2\d{2}\b\w{0,1}\b')),
      findsAtLeast(1),
    );
    expect(find.textContaining(RegExp(r'\b3\d{2}\b\w{0,1}\b')), findsNothing);
    expect(find.textContaining(RegExp(r'\b4\d{2}\b\w{0,1}\b')), findsNothing);
    expect(find.textContaining(RegExp(r'\b5\d{2}\b\w{0,1}\b')), findsNothing);
  });

  testWidgets('Search by Term', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final termDropdown = find.byKey(const Key('Term Dropdown'));
    final spring = find.textContaining('Spring');
    final winter = find.textContaining('Winter');

    expect(termDropdown.hitTestable(), findsOneWidget);
    expect(spring.hitTestable(), findsNothing);
    expect(winter.hitTestable(), findsNothing);

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

  testWidgets('Search by Credits', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final creditDropdown = find.byKey(const Key('Credits Dropdown'));
    final any = find.text('Any');
    final oneCredit = find.text('1');
    final twoCredit = find.text('2');
    final threeCredit = find.text('3');
    final fourCredit = find.text('4');
    final moreCredit = find.text('>4');

    expect(creditDropdown.hitTestable(), findsOneWidget);
    expect(any.hitTestable(), findsNothing);
    expect(oneCredit.hitTestable(), findsNothing);
    expect(twoCredit.hitTestable(), findsNothing);
    expect(threeCredit.hitTestable(), findsNothing);
    expect(fourCredit.hitTestable(), findsNothing);
    expect(moreCredit.hitTestable(), findsNothing);

    await tester.tap(creditDropdown);
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsOneWidget);
    expect(oneCredit.hitTestable(), findsOneWidget);
    expect(twoCredit.hitTestable(), findsOneWidget);
    expect(threeCredit.hitTestable(), findsOneWidget);
    expect(fourCredit.hitTestable(), findsOneWidget);
    expect(moreCredit.hitTestable(), findsOneWidget);

    await tester.tap(fourCredit.hitTestable());
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsNothing);
    expect(oneCredit.hitTestable(), findsNothing);
    expect(twoCredit.hitTestable(), findsNothing);
    expect(threeCredit.hitTestable(), findsNothing);
    expect(fourCredit.hitTestable(), findsAtLeast(1));
    expect(moreCredit.hitTestable(), findsNothing);
    final finder = find.byKey(const Key('Cr Cell'));
    expect(finder, findsWidgets);
    expect(
      find.descendant(of: finder, matching: find.textContaining('4')),
      findsAtLeast(1),
    );
  });

  testWidgets('Search by Start Time', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final timeDropdown = find.byKey(const Key('Start Time Dropdown'));
    final any = find.text('Any Time');
    final eightAM = find.text('8:00AM');
    final nineAM = find.text('9:00AM');
    final tenAM = find.text('10:00AM');

    expect(timeDropdown.hitTestable(), findsOneWidget);
    expect(any.hitTestable(), findsAtLeast(2));
    expect(eightAM.hitTestable(), findsNothing);
    expect(nineAM.hitTestable(), findsNothing);
    expect(tenAM.hitTestable(), findsNothing);

    await tester.tap(timeDropdown);
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsAtLeast(2));
    expect(eightAM.hitTestable(), findsOneWidget);
    expect(nineAM.hitTestable(), findsOneWidget);
    expect(tenAM.hitTestable(), findsOneWidget);

    await tester.tap(tenAM.hitTestable());
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsAtLeast(1));
    expect(eightAM.hitTestable(), findsNothing);
    expect(nineAM.hitTestable(), findsNothing);
    expect(tenAM.hitTestable(), findsAtLeast(1));
    final finder = find.byKey(const Key('Schedule Cell'));
    expect(finder, findsWidgets);
    expect(
      find.descendant(of: finder, matching: find.textContaining('10:00')),
      findsAtLeast(1),
    );
  });

  testWidgets('Search by End Time', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final timeDropdown = find.byKey(const Key('End Time Dropdown'));
    final any = find.text('Any Time');
    final eightAM = find.text('8:50AM');
    final nineAM = find.text('9:50AM');
    final tenAM = find.text('10:50AM');

    expect(timeDropdown.hitTestable(), findsOneWidget);
    expect(any.hitTestable(), findsAtLeast(2));
    expect(eightAM.hitTestable(), findsNothing);
    expect(nineAM.hitTestable(), findsNothing);
    expect(tenAM.hitTestable(), findsNothing);

    await tester.tap(timeDropdown);
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsAtLeast(2));
    expect(eightAM.hitTestable(), findsOneWidget);
    expect(nineAM.hitTestable(), findsOneWidget);
    expect(tenAM.hitTestable(), findsOneWidget);

    await tester.tap(tenAM.hitTestable());
    await tester.pumpAndSettle();
    expect(any.hitTestable(), findsAtLeast(1));
    expect(eightAM.hitTestable(), findsNothing);
    expect(nineAM.hitTestable(), findsNothing);
    expect(tenAM.hitTestable(), findsAtLeast(1));
    final finder = find.byKey(const Key('Schedule Cell'));
    expect(finder, findsWidgets);
    expect(
      find.descendant(of: finder, matching: find.textContaining('10:50')),
      findsAtLeast(1),
    );
  });

  testWidgets('Search by Class Number', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    final one122 = find.text('1122');
    final one414 = find.text('1414');
    final one321 = find.text('1321');

    final classNumberTextBox = find.byKey(const Key('Class Number Text Box'));

    expect(classNumberTextBox.hitTestable(), findsOneWidget);
    expect(one122, findsNothing);
    expect(one414, findsNothing);
    expect(one321, findsNothing);

    await tester.enterText(classNumberTextBox, '1122');
    await tester.pumpAndSettle();
    expect(one122, findsAtLeast(1));
    expect(one414, findsNothing);
    expect(one321, findsNothing);

    await tester.enterText(classNumberTextBox, '1414');
    await tester.pumpAndSettle();
    expect(one122, findsNothing);
    expect(one414, findsAtLeast(1));
    expect(one321, findsNothing);

    await tester.enterText(classNumberTextBox, '1321');
    await tester.pumpAndSettle();
    expect(one122, findsNothing);
    expect(one414, findsNothing);
    expect(one321, findsAtLeast(1));
  });

  testWidgets('Search by Instructor', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    final schaffner = find.text('Brian Schaffner');
    final wong = find.text('Brian Wong');

    final instructorTextBox = find.byKey(const Key('Instructor Text Box'));

    expect(instructorTextBox.hitTestable(), findsOneWidget);
    expect(schaffner.hitTestable(), findsNothing);
    expect(wong.hitTestable(), findsNothing);

    await tester.enterText(instructorTextBox, 'Brian Schaffner');
    await tester.pumpAndSettle();
    expect(schaffner.hitTestable(), findsAtLeast(1));
    expect(wong.hitTestable(), findsNothing);

    await tester.enterText(instructorTextBox, 'Brian Wong');
    await tester.pumpAndSettle();
    expect(schaffner.hitTestable(), findsNothing);
    expect(wong.hitTestable(), findsAtLeast(1));

    await tester.enterText(instructorTextBox, 'Brian');
    await tester.pumpAndSettle();
    expect(schaffner.hitTestable(), findsAtLeast(1));
    expect(wong.hitTestable(), findsAtLeast(1));
  });

  testWidgets('Search by Only Open', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    final onlyOpenCheckBox = find.byKey(const Key('Status Checkbox'));

    // Check if the checkbox is tappable.
    expect(onlyOpenCheckBox.hitTestable(), findsOneWidget);

    // Tap the checkbox.
    await tester.tap(onlyOpenCheckBox);
    await tester.pumpAndSettle();

    final classText =
        find.byKey(const Key('Class Found')).evaluate().single.widget as Text;
    final classesFound = classText.data!.trim();

    expect(classesFound, equals('2371 classes found.'));
  });

  testWidgets('Search by Only GS', (WidgetTester tester) async {
    // Testing data has all classes listed as General Studies...
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    final generalStudiesCheckBox = find.byKey(const Key('GS Checkbox'));

    // Check if the checkbox is tappable.
    expect(generalStudiesCheckBox.hitTestable(), findsOneWidget);

    // Tap the checkbox.
    await tester.tap(generalStudiesCheckBox);
    await tester.pumpAndSettle();

    final classText =
        find.byKey(const Key('Class Found')).evaluate().single.widget as Text;
    final classesFound = classText.data!.trim();

    expect(classesFound, equals('2371 classes found.'));
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
    final csDepartment = find.text('CPTR Computer Science');
    await tester.tap(csDepartment.hitTestable());
    await tester.pumpAndSettle();

    // verify sort order of subject number
    String prior = '';
    String next = '';
    final itemFinder = find.byKey(const Key('Class'));
    for (final each in itemFinder.evaluate()) {
      final subject = textInCellWithKey(each, 'Subject Cell');
      final summer1 = textInCellWithKey(each, 'Summer1 Cell');
      final fall = textInCellWithKey(each, 'Fall Cell');
      final winter = textInCellWithKey(each, 'Winter Cell');
      final spring = textInCellWithKey(each, 'Spring Cell');
      final summer2 = textInCellWithKey(each, 'Summer2 Cell');
      final section = textInCellWithKey(each, 'Section Cell');
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
