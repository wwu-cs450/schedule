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
import 'package:schedule_client/views/search_criteria.dart';

void main() {
  // For RegExp calls, look up documentation for Regex symbols.
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  Future<void> buildTestEnvironment(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(2000, 1000));
    await tester.pumpWidget(const MyApp());
    final context = tester.element(find.byType(MyApp));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      results = SearchCriteria(context);
    });
  }

  Future<void> doTap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> insertText(
    WidgetTester tester,
    FinderBase<Element> finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  final Map<String, Finder> finders = {
    'Department': find.byKey(const Key('Department Dropdown')).hitTestable(),
    'Subject': find.byKey(const Key('Subject Dropdown')).hitTestable(),
    'Campus': find.byKey(const Key('Campus Dropdown')).hitTestable(),
    'Level': find.byKey(const Key('Level Dropdown')).hitTestable(),
    'Term': find.byKey(const Key('Term Dropdown')).hitTestable(),
    'Credits': find.byKey(const Key('Credits Dropdown')).hitTestable(),
    'Schedule': find.byKey(const Key('Schedule Dropdown')).hitTestable(),
    'Start Time': find.byKey(const Key('Start Time Dropdown')).hitTestable(),
    'End Time': find.byKey(const Key('End Time Dropdown')).hitTestable(),
    'Class Number':
        find.byKey(const Key('Class Number Text Box')).hitTestable(),
    'Instructors': find.byKey(const Key('Instructor Text Box')).hitTestable(),
    'Status': find.byKey(const Key('Status Checkbox')).hitTestable(),
    'GS': find.byKey(const Key('GS Checkbox')).hitTestable(),
  };

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

  List<dynamic> excludeIndex(List<dynamic> list, int index) {
    return list.where((item) => list.indexOf(item) != index).toList();
  }

  void multiExpect(List<dynamic> actual, dynamic matcher, {String? except}) {
    if (actual.runtimeType != List<Finder>) {
      for (final each in actual) {
        expect(find.text(each.toString()), matcher);
      }
    } else {
      for (final each in actual) {
        expect(each, matcher);
      }
    }
  }

  void expectInResults(List<String> keys, dynamic condition) {
    for (final key in keys) {
      for (final each in find
          .byWidgetPredicate(
            (Widget widget) =>
                widget.key is ValueKey<String> &&
                RegExp(r'^Class \d{0,4}')
                    .hasMatch((widget.key as ValueKey<String>).value) &&
                widget is Row,
          )
          .evaluate()) {
        if (condition != isNot('')) {
          if (textInCellWithKey(each, '$key Cell') != '') {
            expect(textInCellWithKey(each, '$key Cell'), condition);
          }
        } else {
          expect(textInCellWithKey(each, '$key Cell'), condition);
        }
      }
    }
  }

  Future<void> dropdownTester(
    WidgetTester tester, {
    required String menu,
    required List<String> options,
    required dynamic condition,
    required List<String> cellKeys,
  }) async {
    await buildTestEnvironment(tester);
    final ddownOpts = options.map((e) => find.text(e).hitTestable()).toList();
    multiExpect(ddownOpts, findsNothing);
    await doTap(tester, finders[menu]!);
    multiExpect(ddownOpts, findsOneWidget);
    await doTap(tester, ddownOpts[2]);
    expect(ddownOpts[2], findsOneWidget);
    multiExpect(excludeIndex(ddownOpts, 2), findsNothing);
    expectInResults(cellKeys, condition);
  }

  Future<void> textBoxTester(
    WidgetTester tester, {
    required String textField,
    required List<String> txtOpts,
    required List<String> cellKeys,
  }) async {
    await buildTestEnvironment(tester);
    multiExpect(txtOpts, findsNothing);
    for (final opt in txtOpts) {
      await insertText(tester, finders[textField]!, opt);
      expectInResults(cellKeys, equals(opt));
      multiExpect(
        excludeIndex(txtOpts, txtOpts.indexOf(opt)),
        findsNothing,
      );
    }
  }

  testWidgets('Search Criteria Test', (WidgetTester tester) async {
    await buildTestEnvironment(tester);

    multiExpect(
      finders.values.toList(),
      findsOneWidget,
    );
  });

  testWidgets('Search Criteria does not Overlap with Results',
      (WidgetTester tester) async {
    await buildTestEnvironment(tester);

    expect(find.byKey(const Key('Search Criteria Widget')), findsOneWidget);
  });

  testWidgets('Header Card Test', (WidgetTester tester) async {
    await buildTestEnvironment(tester);

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget.key is ValueKey<String> &&
            RegExp(r'Header Card$')
                .hasMatch((widget.key as ValueKey<String>).value),
      ),
      findsExactly(22),
    );
  });

  testWidgets('Search by Department', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Department',
      options: ['ACDM Acadeum', 'CHEM Chemistry', 'ENGI Engineering'],
      condition: equals('ENGR'),
      cellKeys: ['Subject'],
    );
  });

  testWidgets('Search by Subject', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Subject',
      options: ['ACCT Accounting', 'ART Art', 'BUAD Business Administration'],
      condition: equals('ACCT'),
      cellKeys: ['Subject'],
    );
  });

  testWidgets('Search by Campus', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Campus',
      options: ['BI Billings', 'CP College Place', 'RO Rosario'],
      condition: equals('RO'),
      cellKeys: ['Campus'],
    );
  });

  testWidgets('Search by Level', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Level',
      options: ['Lower', 'Upper', 'Grad'],
      condition: contains(RegExp(r'\b5\d{2}\b\w{0,1}\b')),
      cellKeys: ['Summer1', 'Fall', 'Winter', 'Spring', 'Summer2'],
    );
  });

  testWidgets('Search by Term', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Term',
      options: ['Fall 2023', 'Winter 2024', 'Spring 2024'],
      condition: isNot(''),
      cellKeys: ['Spring'],
    );
  });

  testWidgets('Search by Credits', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Credits',
      options: ['1', '2', '3', '4', '>4'],
      condition: equals('3.0'),
      cellKeys: ['Cr'],
    );
  });

  testWidgets('Search by Day', (WidgetTester tester) async {
    // As this is a custom widget, the default format doesn't work.
    await buildTestEnvironment(tester);

    final ddownOpts = [
      find.text('Monday').hitTestable(),
      find.text('Tuesday').hitTestable(),
      find.text('Wednesday').hitTestable(),
    ];

    multiExpect(ddownOpts, findsNothing);

    await doTap(tester, finders['Schedule']!);
    multiExpect(ddownOpts, findsOneWidget);

    // Check both monday and tuesday
    await tester.tap(ddownOpts[0]);
    await tester.tap(ddownOpts[1]);
    expectInResults(['Schedule'], contains('MT'));

    // Check both monday and wednesday
    await tester.tap(ddownOpts[1]);
    await tester.tap(ddownOpts[2]);
    expectInResults(['Schedule'], contains('MW'));
  });

  testWidgets('Search by Start Time', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'Start Time',
      options: ['8:00AM', '9:00AM', '10:00AM'],
      condition: contains('10:00AM'),
      cellKeys: ['Schedule'],
    );
  });

  testWidgets('Search by End Time', (WidgetTester tester) async {
    await dropdownTester(
      tester,
      menu: 'End Time',
      options: ['8:50AM', '9:50AM', '10:50AM'],
      condition: contains('10:50AM'),
      cellKeys: ['Schedule'],
    );
  });

  testWidgets('Search by Class Number', (WidgetTester tester) async {
    await textBoxTester(
      tester,
      textField: 'Class Number',
      txtOpts: ['1122', '1222', '1322'],
      cellKeys: ['Class Number'],
    );
  });

  testWidgets('Search by Instructor', (WidgetTester tester) async {
    final textOpts = ['Brian Schaffner', 'Brian Wong', 'Brian Harris'];
    await textBoxTester(
      tester,
      textField: 'Instructors',
      txtOpts: textOpts,
      cellKeys: ['Instructors'],
    );
    await insertText(tester, finders['Instructors']!, 'Brian');
    multiExpect(textOpts, findsAtLeast(1));
  });

  testWidgets('Search by Only Open', (WidgetTester tester) async {
    await buildTestEnvironment(tester);
    await doTap(tester, finders['Status']!);
    expectInResults(['Status'], equals('Open'));
  });

  testWidgets('Search by Only GS', (WidgetTester tester) async {
    await buildTestEnvironment(tester);
    await doTap(tester, finders['GS']!);
    expectInResults(['GS'], equals('GS'));
  });

  testWidgets('Schedule View Test', (WidgetTester tester) async {
    await buildTestEnvironment(tester);
    final options = {
      '9:00AM': find.text('9:00AM').hitTestable(),
      'Biology': find.text('BIOL Biology').hitTestable(),
      'Schedule Page': find.byKey(const Key('Schedule Page')).hitTestable(),
      'Main Page': find.byKey(const Key('Main Page')).hitTestable(),
    };
    final termOptions = [
      find.text('Fall 2023').hitTestable(),
      find.text('Winter 2024').hitTestable(),
      find.text('Spring 2024').hitTestable(),
    ];

    await doTap(tester, finders['Department']!);
    await doTap(tester, options['Biology']!);

    await doTap(tester, finders['Start Time']!);
    await doTap(tester, options['9:00AM']!);

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
      final fallContent = textInCellWithKey(row, 'Fall Cell');
      final wtrContent = textInCellWithKey(row, 'Winter Cell');
      final sprContent = textInCellWithKey(row, 'Spring Cell');
      if ((fall2023 < 1) && (fallContent != '')) {
        await doTap(tester, saveBox);
        fall2023++;
      } else if ((winter2024 < 2) && (wtrContent != '')) {
        await doTap(tester, saveBox);
        winter2024++;
      } else if ((spring2024 < 3) && (sprContent != '')) {
        await doTap(tester, saveBox);
        spring2024++;
      }
    }

    // Qualifies as Nav-Bar test.
    expect(options['Schedule Page'], findsOneWidget);
    await doTap(tester, options['Schedule Page']!);
    expect(finders['Department']!, findsNothing);

    // Qualifies as Schedule View test.
    final redBox = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color ==
              const Color.fromARGB(255, 255, 130, 121),
    );
    final termDropdown = find.byKey(const Key('Schedule View Term Dropdown'));

    expect(termDropdown.hitTestable(), findsOneWidget);
    expect(redBox, findsNothing);

    await doTap(tester, termDropdown);
    expect(termOptions[0], findsAtLeast(1));
    multiExpect(excludeIndex(termOptions, 0), findsOneWidget);

    await doTap(tester, termOptions[1]);
    expect(redBox, findsAtLeast(1));

    await doTap(tester, termDropdown);
    await doTap(tester, termOptions[2]);
    expect(redBox, findsAtLeast(1));
  });

  testWidgets('Default Sort', (WidgetTester tester) async {
    await buildTestEnvironment(tester);

    // Open department dropdown
    await doTap(tester, finders['Department']!);
    await doTap(tester, find.text('CPTR Computer Science').hitTestable());

    // verify sort order of subject number
    String prior = '';
    String next = '';
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
  });
}
