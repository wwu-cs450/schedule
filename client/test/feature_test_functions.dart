// This is a basic Flutter widget test.
//
// Note, this description may be outdated.
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_functions.dart';

Future<void> searchCriteriaTest(WidgetTester tester, double width) async {
  await buildTestEnvironment(tester, width);
  await openDrawer(tester);

  multiExpect(
    finders.values.toList(),
    findsOneWidget,
  );
}

Future<void> headerCellTest(
  WidgetTester tester,
  double width, {
  required int numCells,
}) async {
  await buildTestEnvironment(tester, width);
  expect(
    find.byWidgetPredicate(
      (Widget widget) =>
          widget.key is ValueKey<String> &&
          RegExp(r'Header Card$')
              .hasMatch((widget.key as ValueKey<String>).value),
    ),
    findsExactly(numCells),
  );
}

Future<void> departmentTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Department',
    options: ['ACDM Acadeum', 'CHEM Chemistry', 'CPTR Computer Science'],
    condition: requirement,
    cellKeys: ['Subject'],
    testerWidth: width,
  );
}

Future<void> subjectTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Subject',
    options: ['ACCT Accounting', 'ART Art', 'AVIA Aviation'],
    condition: requirement,
    cellKeys: ['Subject'],
    testerWidth: width,
  );
}

Future<void> campusTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Campus',
    options: ['BI Billings', 'CP College Place', 'CMC Christian Music Center'],
    condition: requirement,
    cellKeys: ['Campus'],
    testerWidth: width,
  );
}

Future<void> levelTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  final List<String> keys = width >= 2000
      ? ['Summer1', 'Fall', 'Winter', 'Spring', 'Summer2']
      : ['Subject'];
  await dropdownTester(
    tester,
    menu: 'Level',
    options: ['Lower', 'Upper', 'Grad'],
    condition: requirement,
    cellKeys: keys,
    testerWidth: width,
  );
}

Future<void> termTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Term',
    options: ['Fall 2023', 'Winter 2024', 'Spring 2024'],
    condition: requirement,
    cellKeys: ['Spring'],
    testerWidth: width,
  );
}

Future<void> creditTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Credits',
    options: ['1 Cr', '2 Cr', '3 Cr', '4 Cr', '>4 Cr'],
    condition: requirement,
    cellKeys: ['Cr'],
    testerWidth: width,
  );
}

Future<void> dayTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  await buildTestEnvironment(tester, width);
  final ddownOpts = [
    find.text('Monday').hitTestable(),
    find.text('Tuesday').hitTestable(),
    find.text('Wednesday').hitTestable(),
  ];
  await openDrawer(tester);
  multiExpect(ddownOpts, findsNothing);
  await doTap(tester, finders['Schedule']!);
  multiExpect(ddownOpts, findsOneWidget);
  // Check both monday and tuesday
  await doTap(tester, ddownOpts[0]);
  await doTap(tester, ddownOpts[1]);
  expectInResults(['Schedule'], contains('MT'), type: type);
  // Check both monday and wednesday
  await doTap(tester, ddownOpts[2]);
  expectInResults(['Schedule'], contains('MTW'), type: type);
  // Reverse to MT
  await doTap(tester, ddownOpts[2]);
  expectInResults(['Schedule'], contains('MT'), type: type);
}

Future<void> startTimeTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'Start Time',
    options: ['8:00AM', '9:00AM', '10:00AM'],
    condition: requirement,
    cellKeys: ['Schedule'],
    testerWidth: width,
  );
}

Future<void> endTimeTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await dropdownTester(
    tester,
    menu: 'End Time',
    options: ['8:50AM', '9:50AM', '10:50AM'],
    condition: requirement,
    cellKeys: ['Schedule'],
    testerWidth: width,
  );
}

Future<void> classNumberTest(WidgetTester tester, double width) async {
  await textBoxTester(
    tester,
    textField: 'Class Number',
    txtOpts: ['1122', '1222', '1322'],
    cellKeys: ['Class Number'],
    testerWidth: width,
  );
}

Future<void> instructorTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  final textOpts = ['Brian Schaffner', 'Brian Wong', 'Brian Harris'];
  await textBoxTester(
    tester,
    textField: 'Instructors',
    txtOpts: textOpts,
    cellKeys: ['Instructors'],
    testerWidth: width,
  );
  await insertText(tester, finders['Instructors']!, 'Brian');
  type == 'Wide'
      ? multiExpect(textOpts, findsAtLeast(1))
      : type == 'Medium'
          ? hoverExpect(
              tester,
              find.byKey(const Key('Hover Cell')),
              find.textContaining('Brian'),
            )
          : expectInResults(['Instructor'], contains('Brian'), type: type);
}

Future<void> statusTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
  required String type,
}) async {
  await buildTestEnvironment(tester, width);
  await openDrawer(tester);
  await doTap(tester, finders['Status']!);
  expectInResults(['Status'], requirement, type: type);
}

Future<void> gsTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
  required String type,
}) async {
  await buildTestEnvironment(tester, width);
  await openDrawer(tester);
  await doTap(tester, finders['GS']!);
  expectInResults(['GS'], requirement, type: type);
}

Future<void> scheduleViewTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  final dataContainer = type == 'Wide' || type == 'Medium' ? 'Cell' : 'Row';
  await buildTestEnvironment(tester, width);
  final options = {
    '9:00AM': find.text('9:00AM').hitTestable(),
    'Biology': find.text('BIOL Biology').hitTestable(),
    'Schedule Page': find.byKey(const Key('Schedule Page')).hitTestable(),
    'Main Page': find.byKey(const Key('Main Page')).hitTestable(),
  };
  final termOptions = [
    find.text('Fall 2024').hitTestable(),
    find.text('Winter 2025').hitTestable(),
    find.text('Spring 2025').hitTestable(),
  ];

  await openDrawer(tester);
  await doTap(tester, finders['Department']!);
  await doTap(tester, options['Biology']!);
  await doTap(tester, finders['Start Time']!);
  await doTap(tester, options['9:00AM']!);
  await closeDrawer(tester);
  int fall2023 = 0, winter2024 = 0, spring2024 = 0;
  final rows = find
      .byWidgetPredicate(
        (Widget widget) =>
            widget.key is ValueKey<String> &&
            RegExp(r'^Class \d{0,4}')
                .hasMatch((widget.key as ValueKey<String>).value) &&
            widget is Row,
      )
      .evaluate();

  // Qualifies as Save Box test.
  for (final row in rows) {
    final saveBox =
        find.byKey(Key('Class ${rows.toList().indexOf(row)} save box'));
    final fallContent = textInCellWithKey(row, 'Fall $dataContainer');
    final wtrContent = textInCellWithKey(row, 'Winter $dataContainer');
    final sprContent = textInCellWithKey(row, 'Spring $dataContainer');
    if ((fall2023 < 1) && (fallContent != ' ')) {
      await doTap(tester, saveBox);
      fall2023++;
    } else if ((winter2024 < 2) && (wtrContent != ' ')) {
      await doTap(tester, saveBox);
      winter2024++;
    } else if ((spring2024 < 3) && (sprContent != ' ')) {
      await doTap(tester, saveBox);
      spring2024++;
    }
  }

  // Qualifies as Nav-Bar test.
  expect(options['Schedule Page'], findsOneWidget);
  await doTap(tester, options['Schedule Page']!);
  expect(finders['Department']!, findsNothing);

  // Qualifies as Schedule View test.
  // Also qualifies as download button test.
  final redBox = find.byWidgetPredicate(
    (Widget widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color ==
            const Color.fromARGB(255, 255, 130, 121),
  );
  final termDropdown = find.byKey(const Key('Schedule View Term Dropdown'));
  final downloadButton = find.byKey(const Key('Download Button'));
  final downloadVerification = find.text('Downloaded');

  expect(termDropdown.hitTestable(), findsOneWidget);
  expect(downloadButton.hitTestable(), findsOneWidget);
  expect(redBox, findsNothing);

  await doTap(tester, downloadButton);
  expect(downloadVerification, findsOneWidget);

  await doTap(tester, termDropdown);
  expect(termOptions[0], findsAtLeast(1));
  multiExpect(excludeIndex(termOptions, 0), findsOneWidget);

  await doTap(tester, termOptions[0]);
  expect(find.byKey(const Key('totalCreditsText')), findsOneWidget);
  expect(find.text('Total Credits: 4.0'), findsOneWidget);

  await doTap(tester, termDropdown);
  await doTap(tester, termOptions[1]);
  expect(redBox, findsAtLeast(1));

  await doTap(tester, termDropdown);
  await doTap(tester, termOptions[2]);
  expect(redBox, findsAtLeast(1));
}

Future<void> defaultSortTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  await buildTestEnvironment(tester, width);

  // Open department dropdown
  await openDrawer(tester);
  await doTap(tester, finders['Department']!);
  await doTap(tester, find.text('CPTR Computer Science').hitTestable());

  // verify sort order of subject number
  String prior = '';
  String next = '';

  if (type == 'Wide') {
    for (final each in find.byKey(const Key('Class')).evaluate()) {
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
  } else if (type == 'Medium') {
    for (final each in find.byKey(const Key('Class')).evaluate()) {
      final splitData = textInCellWithKey(each, 'Subject Cell').split(' ');
      final subject = splitData[0];
      final number = splitData[1];
      final section = textInCellWithKey(each, 'Section Cell');
      late int term;
      final termCellData = textInCellWithKey(each, 'Term Row');
      if (termCellData == 'Sum $startYear') {
        term = 1;
      } else if (termCellData == 'Aut $startYear') {
        term = 2;
      } else if (termCellData == 'Wtr ${startYear + 1}') {
        term = 3;
      } else if (termCellData == 'Spr ${startYear + 1}') {
        term = 4;
      } else if (termCellData == 'Sum ${startYear + 1}') {
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
  } else if (type == 'Small') {
    for (final each in find.byKey(const Key('Class')).evaluate()) {
      final splitData = textInCellWithKey(each, 'Subject Row').split('');
      final subject = splitData[0];
      final number = splitData[1];
      final section = splitData.length == 3 ? splitData[2] : null;
      late int term;
      if (textInCellWithKey(each, 'Summer Row') == 'Summer $startYear') {
        term = 1;
      } else if (textInCellWithKey(each, 'Fall Row') == 'Fall $startYear') {
        term = 2;
      } else if (textInCellWithKey(each, 'Winter Row') ==
          'Winter ${startYear + 1}') {
        term = 3;
      } else if (textInCellWithKey(each, 'Spring Row') ==
          'Spring ${startYear + 1}') {
        term = 4;
      } else if (textInCellWithKey(each, 'Summer Row') ==
          'Summer ${startYear + 1}') {
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
  }
}

Future<void> mediumTermTest(WidgetTester tester) async {
  bool foundFlag = false;
  late bool colorFlag;
  late bool termFlag;
  // Summer, Fall, Winter, Spring
  final List<List<int>> colors = [
    [0xFFf1f276, 0xFFf2b600, 0xFF8ca2bd, 0xFF53b573],
    [0xFFfeffa4, 0xFFffd34d, 0xFFb4c4d8, 0xFF8ad2a1],
  ];
  final specificRow = find.byWidgetPredicate(
    (Widget widget) =>
        widget.key is ValueKey<String> &&
        RegExp(r'^Class \d{0,4}')
            .hasMatch((widget.key as ValueKey<String>).value) &&
        widget is Row,
  );
  await buildTestEnvironment(tester, 970);
  await openDrawer(tester);
  await doTap(tester, finders['Department']!);
  await doTap(tester, find.text('CPTR Computer Science').hitTestable());
  await closeDrawer(tester);
  for (final row in specificRow.evaluate()) {
    final number = textInCellWithKey(row, 'ClassNumber Cell');
    final termContainer =
        descendWidgetTree(row, 'Term Color Cell') as Container;
    final termText = termContainer.child as Text;
    final termData = termText.data!.split(' ')[0];
    final termDecoration = termContainer.decoration! as BoxDecoration;
    if (number == '1408') {
      foundFlag = true;
      if (termData == 'Aut') {
        termFlag = true;
      } else {
        termFlag = false;
      }
      if (termDecoration.color == Color(colors[0][1]) ||
          termDecoration.color == Color(colors[1][1])) {
        colorFlag = true;
      } else {
        colorFlag = false;
      }
    }
  }
  expect(foundFlag, isTrue, reason: '  Reason: Class Number 1408 not found.');
  if (foundFlag) {
    expect(colorFlag, isTrue, reason: '  Reason: Color is incorrect.');
    expect(termFlag, isTrue, reason: '  Reason: Term is incorrect.');
  }
}

Future<void> auditViewTest(WidgetTester tester) async {
  await buildTestEnvironment(tester, 970);
  final options = {
    'Audit Page': find.byKey(const Key('Audit Page')).hitTestable(),
    'Main Page': find.byKey(const Key('Main Page')).hitTestable(),
  };
  expect(options['Audit Page'], findsOneWidget);
  await doTap(tester, options['Audit Page']!);
  // Find the TextField and enter text
  final textFieldFinder = find.byKey(const Key('Audit TextField'));
  await tester.enterText(
    textFieldFinder,
    'This is pasted text',
  );

  // Tap the submit button
  final submitButtonFinder = find.byKey(const Key('Submit Button'));
  await tester.tap(submitButtonFinder);
  await tester.pump();

  expect(
    find.text('This is pasted text'),
    findsAtLeast(1),
  );

  // Verify that the TextField is scrollable
  final scrollableFinder = find.byType(SingleChildScrollView);
  expect(scrollableFinder, findsOneWidget);
}
