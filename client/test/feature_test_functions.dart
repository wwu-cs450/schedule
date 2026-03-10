// This is a basic Flutter widget test.
//
// Note, this description may be outdated.
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:client/views/audit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_functions.dart';

const startYear = 2024;

Future<void> searchCriteriaTest(WidgetTester tester, double width) async {
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  // Verify filter menu is open by checking for filter sections
  expect(find.text('Select filters below'), findsOneWidget);
}

Future<void> headerCellTest(
  WidgetTester tester,
  double width, {
  required int numCells,
}) async {
  await buildTestEnvironment(tester, width: width);
  expect(
    find.byWidgetPredicate(
      (Widget widget) =>
          widget.key is ValueKey<String> &&
          RegExp(
            r'Header Card$',
          ).hasMatch((widget.key as ValueKey<String>).value),
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
    options: ['ACDM - Acadeum', 'CHEM - Chemistry', 'CPTR - Computer Science'],
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
    options: ['ACCT - Accounting', 'ART - Art', 'AVIA - Aviation'],
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
    options: [
      'BI - Billings',
      'CP - College Place',
      'CMC - Christian Music Center',
    ],
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
  final String type = width > 965 ? 'Wide' : 'Small';

  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  // Level section may be below the fold — scroll to it if necessary.
  final levelSection = find.text('Level');
  if (levelSection.hitTestable().evaluate().isEmpty) {
    final scrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    if (scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        levelSection,
        100,
        scrollable: scrollable.first,
      );
    }
  }
  await tester.tap(levelSection.hitTestable());
  await tester.pumpAndSettle();

  // Deselect Lower and Upper, leaving only Grad selected.
  await doTap(tester, find.text('Lower (100-299)').hitTestable());
  await doTap(tester, find.text('Upper (300-499)').hitTestable());

  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  expectInResults(keys, requirement, type: type);
}

Future<void> termTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  // Term is a ShadSelect widget at the top of the menu, not an expandable
  // checkbox section. Find it by its stable key and open the dropdown.
  final termSelect = find.byKey(const Key('Term Select')).hitTestable();
  await tester.tap(termSelect);
  await tester.pumpAndSettle();

  // Select the third term option used for testing.
  final option = find.text('Spring 2024').hitTestable();
  await tester.tap(option);
  await tester.pumpAndSettle();

  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  final String type = width > 965 ? 'Wide' : 'Small';
  expectInResults(['Spring'], requirement, type: type);
}

Future<void> creditTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  // Credits defaults to all six selected, same as Level. dropdownTester's
  // "tap Select all twice" trick would uncheck '3 Cr' instead of selecting
  // it, so we handle this manually.
  final String type = width > 965 ? 'Wide' : 'Small';

  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  final scrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );

  // Credits section may be below the fold — scroll to it if necessary.
  final creditsSection = find.text('Credits');
  if (creditsSection.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      creditsSection,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(creditsSection.hitTestable());
  await tester.pumpAndSettle();

  // Deselect all except '3 Cr'. Scroll to each option before tapping since
  // the expanded list may extend beyond the visible area.
  for (final option in ['0 Cr', '1 Cr', '2 Cr', '4 Cr', '>4 Cr']) {
    final item = find.text(option);
    if (item.hitTestable().evaluate().isEmpty &&
        scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(item, 100, scrollable: scrollable.first);
    }
    await doTap(tester, item.hitTestable());
  }

  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  expectInResults(['Cr'], requirement, type: type);
}

Future<void> dayTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  await buildTestEnvironment(tester, width: width);

  // Helper: open the filter menu and expand the Schedule section.
  // The section collapses whenever the menu is closed, so this must be
  // called each time the menu is reopened.
  Future<void> openAndExpandSchedule() async {
    await openFilterMenu(tester);
    final scrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    // Scope to the SingleChildScrollView to avoid matching the nav bar's
    // "Schedule" tab, which would cause scrollUntilVisible to throw.
    final scheduleSection = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.text('Schedule'),
    );
    if (scheduleSection.hitTestable().evaluate().isEmpty &&
        scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        scheduleSection,
        100,
        scrollable: scrollable.first,
      );
    }
    await tester.tap(scheduleSection.hitTestable());
    await tester.pumpAndSettle();

    // After expanding, scroll to Monday so the day checkboxes are visible.
    if (scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        find.text('Monday'),
        100,
        scrollable: scrollable.first,
      );
    }
  }

  await openAndExpandSchedule();

  // Verify that day checkboxes are visible after expanding.
  // (Using individual expects instead of multiExpect to avoid the
  // List<ChainedFinder> vs List<Finder> runtimeType mismatch in multiExpect.)
  expect(find.text('Monday').hitTestable(), findsOneWidget);
  expect(find.text('Tuesday').hitTestable(), findsOneWidget);
  expect(find.text('Wednesday').hitTestable(), findsOneWidget);

  // All days start checked (the default). Uncheck Sunday, Wednesday,
  // Thursday, and Friday so only Monday + Tuesday remain, giving MT results.
  await doTap(tester, find.text('Sunday').hitTestable());
  await doTap(tester, find.text('Wednesday').hitTestable());
  await doTap(tester, find.text('Thursday').hitTestable());
  await doTap(tester, find.text('Friday').hitTestable());
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['Schedule'], contains('MT'), type: type);

  // Reopen and also select Wednesday to show MTW classes.
  await openAndExpandSchedule();
  await doTap(tester, find.text('Wednesday').hitTestable());
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['Schedule'], contains('MTW'), type: type);

  // Reopen and deselect Wednesday to return to MT-only.
  await openAndExpandSchedule();
  await doTap(tester, find.text('Wednesday').hitTestable());
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['Schedule'], contains('MT'), type: type);
}

Future<void> startTimeTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  final String type = width > 965 ? 'Wide' : 'Small';
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  final scrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );

  // Scope to SingleChildScrollView to avoid matching other 'Time' text.
  final timeSection = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.text('Time'),
  );
  if (timeSection.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      timeSection,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(timeSection.hitTestable());
  await tester.pumpAndSettle();

  final startTimeSelect = find.byKey(const Key('Start Time Select'));
  if (startTimeSelect.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      startTimeSelect,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(startTimeSelect.hitTestable());
  await tester.pumpAndSettle();

  await tester.tap(find.text('10:00AM').hitTestable().last);
  await tester.pumpAndSettle();

  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  expectInResults(['Schedule'], requirement, type: type);
}

Future<void> endTimeTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
}) async {
  final String type = width > 965 ? 'Wide' : 'Small';
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);

  final scrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );

  // Scope to SingleChildScrollView to avoid matching other 'Time' text.
  final timeSection = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.text('Time'),
  );
  if (timeSection.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      timeSection,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(timeSection.hitTestable());
  await tester.pumpAndSettle();

  final endTimeSelect = find.byKey(const Key('End Time Select'));
  if (endTimeSelect.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      endTimeSelect,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(endTimeSelect.hitTestable());
  await tester.pumpAndSettle();

  await tester.tap(find.text('10:50AM').hitTestable().last);
  await tester.pumpAndSettle();

  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  expectInResults(['Schedule'], requirement, type: type);
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
    textField: 'Instructor',
    txtOpts: textOpts,
    cellKeys: ['Instructors'],
    testerWidth: width,
  );
  await openFilterMenu(tester);
  final instructorField = find
      .byKey(const Key('Instructor Input'))
      .hitTestable();
  await insertText(tester, instructorField, 'Brian');
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  type == 'Wide' || type == 'Large'
      ? multiExpect(textOpts, findsAtLeast(1))
      : type == 'Medium'
      ? hoverExpect(
          tester,
          find.byKey(const Key('Schedule Cell')),
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
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);
  final isOpenChip = find.text('Is Open').hitTestable();
  await doTap(tester, isOpenChip);
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['Is Open'], requirement, type: type);
}

Future<void> gsTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
  required String type,
}) async {
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);
  final gsChip = find.text('General Studies').hitTestable();
  await doTap(tester, gsChip);
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['GS'], requirement, type: type);
}

Future<void> notTakenClassTest(
  WidgetTester tester,
  double width, {
  required Matcher requirement,
  required String type,
}) async {
  await buildTestEnvironment(tester, width: width);
  await openFilterMenu(tester);
  final notTakenChip = find.text('Not Taken').hitTestable();
  await doTap(tester, notTakenChip);
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  expectInResults(['notTaken'], requirement, type: type);
}

Future<void> scheduleViewTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  final dataContainer = type == 'Wide' || type == 'Medium' || type == 'Large'
      ? 'Cell'
      : 'Row';
  await buildTestEnvironment(tester, width: width);
  final options = {
    '9:00AM': find.text('9:00AM').hitTestable(),
    'Biology': find.text('BIOL - Biology').hitTestable(),
    'Schedule Page': find.byKey(const Key('Schedule Page')).hitTestable(),
    'Main Page': find.byKey(const Key('Main Page')).hitTestable(),
  };
  final termOptions = ['Fall 2024', 'Winter 2025', 'Spring 2025'];

  await openFilterMenu(tester);

  // Expand Department section
  final departmentSection = find.text('Department').hitTestable();
  await tester.tap(departmentSection);
  await tester.pumpAndSettle();

  // Scroll down if needed to find Biology option
  final scrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );

  if (scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      options['Biology']!,
      100,
      scrollable: scrollable.first,
    );
  }
  await doTap(tester, options['Biology']!);

  // Expand Time section — scope to SingleChildScrollView to avoid nav-bar match,
  // and scroll to it if it's below the fold.
  final timeSection = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.text('Time'),
  );
  if (timeSection.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      timeSection,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(timeSection.hitTestable());
  await tester.pumpAndSettle();

  // Select start time — scroll to it if needed.
  final startTimeSelect = find.byKey(const Key('Start Time Select'));
  if (startTimeSelect.hitTestable().evaluate().isEmpty &&
      scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      startTimeSelect,
      100,
      scrollable: scrollable.first,
    );
  }
  await tester.tap(startTimeSelect.hitTestable());
  await tester.pumpAndSettle();
  await doTap(tester, options['9:00AM']!);

  await closeFilterMenu(tester);
  int fall2024 = 0, winter2025 = 0, spring2025 = 0;
  final rows = find
      .byWidgetPredicate(
        (Widget widget) =>
            widget.key is ValueKey<String> &&
            RegExp(
              r'^Class \d{0,4}',
            ).hasMatch((widget.key as ValueKey<String>).value) &&
            widget is Row,
      )
      .evaluate();

  // Qualifies as Save Box test.
  for (final row in rows) {
    final saveBox = find.byKey(
      Key('Class ${rows.toList().indexOf(row)} save box'),
    );
    final fallContent = textInCellWithKey(row, 'Fall $dataContainer');
    final wtrContent = textInCellWithKey(row, 'Winter $dataContainer');
    final sprContent = textInCellWithKey(row, 'Spring $dataContainer');
    if ((fall2024 < 1) && (fallContent != ' ')) {
      await doTap(tester, saveBox);
      fall2024++;
    } else if ((winter2025 < 2) && (wtrContent != ' ')) {
      await doTap(tester, saveBox);
      winter2025++;
    } else if ((spring2025 < 3) && (sprContent != ' ')) {
      await doTap(tester, saveBox);
      spring2025++;
    }
  }

  // Qualifies as Nav-Bar test.
  expect(options['Schedule Page'], findsOneWidget);
  await doTap(tester, options['Schedule Page']!);
  // Small schedule view uses ClassListPage, which still renders Filter Button.
  if (type == 'Small') {
    expect(find.byKey(const Key('Filter Button')), findsOneWidget);
  } else {
    expect(find.byKey(const Key('Filter Button')), findsNothing);
  }

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

  expect(termDropdown.hitTestable(), findsOneWidget);
  expect(downloadButton.hitTestable(), findsOneWidget);
  expect(redBox, findsNothing);

  await doTap(tester, downloadButton);

  // correct term is already selected
  expect(find.byKey(const Key('totalCreditsText')), findsOneWidget);
  expect(find.text('Total Credits: 4.0'), findsOneWidget);

  await doTap(tester, termDropdown);
  await doTap(tester, find.text(termOptions[1]).hitTestable().last);
  if (type == 'Small') {
    expect(redBox, findsNothing);
  } else {
    expect(redBox, findsAtLeast(1));
  }

  await doTap(tester, termDropdown);
  await doTap(tester, find.text(termOptions[2]).hitTestable().last);
  if (type == 'Small') {
    expect(redBox, findsNothing);
  } else {
    expect(redBox, findsAtLeast(1));
  }
}

Future<void> defaultSortTest(
  WidgetTester tester,
  double width, {
  required String type,
}) async {
  await buildTestEnvironment(tester, width: width);

  // Open filter menu and select department
  await openFilterMenu(tester);

  // Expand Department section
  final departmentSection = find.text('Department').hitTestable();
  await tester.tap(departmentSection);
  await tester.pumpAndSettle();

  // Scroll to find CPTR if needed
  final cptrOption = find.text('CPTR - Computer Science').hitTestable();
  final scrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );

  if (scrollable.evaluate().isNotEmpty && cptrOption.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      find.text('CPTR - Computer Science'),
      100,
      scrollable: scrollable.first,
    );
  }

  await doTap(tester, find.text('CPTR - Computer Science').hitTestable());
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  // verify sort order of subject number
  String prior = '';
  String next = '';

  if (type == 'Wide' || type == 'Large') {
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
      } else if (termCellData == 'Fal $startYear') {
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
        RegExp(
          r'^Class \d{0,4}',
        ).hasMatch((widget.key as ValueKey<String>).value) &&
        widget is Row,
  );
  await buildTestEnvironment(tester, width: 970);
  await openFilterMenu(tester);

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

  await doTap(tester, find.text('CPTR - Computer Science').hitTestable());
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();
  for (final row in specificRow.evaluate()) {
    final number = textInCellWithKey(row, 'ClassNumber Cell');
    final termContainer =
        descendWidgetTree(row, 'Term Color Cell') as Container;
    final termText = termContainer.child as Text;
    final termData = termText.data!.split(' ')[0];
    final termDecoration = termContainer.decoration! as BoxDecoration;
    if (number == '1408') {
      foundFlag = true;
      if (termData == 'Fal') {
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

Future<void> pdfUploadPageTest(WidgetTester tester, double width) async {
  await buildTestEnvironment(tester, width: width);

  final pdfUploadButton = find
      .byKey(const Key('MyClassHistoryPage'))
      .hitTestable();
  await doTap(tester, pdfUploadButton);

  final selectPdfButton = find.byKey(const Key('Select PDF Button'));
  expect(
    selectPdfButton,
    findsOneWidget,
    reason: '"Select PDF" button should be present.',
  );

  await doTap(tester, selectPdfButton);
  expect(
    find.text('Is this PDF your Audit or Transcript?'),
    findsOneWidget,
    reason: 'The confirmation prompt should appear after selecting a PDF.',
  );

  await doTap(tester, find.text('Audit'));
  expect(
    find.text('No sections found.'),
    findsOneWidget,
    reason: 'The "No sections found" message should appear.',
  );
}

Future<void> auditViewParse(WidgetTester tester, String extractedText) async {
  await buildTestEnvironment(tester, width: 970);
  await tester.pumpWidget(
    MaterialApp(home: AuditPage(extractedText: extractedText)),
  );

  // Confirm each expected header text is found exactly once
  expect(
    find.text('IMPORTANT DEGREE AUDIT INFORMATION (RG 584)'),
    findsOneWidget,
  );
  expect(find.text('FALL THROUGH AND INSUFFICIENT (RG 633)'), findsOneWidget);
  expect(
    find.text('OVERALL UNDERGRADUATE REQUIREMENTS (RG 639)'),
    findsOneWidget,
  );
}
