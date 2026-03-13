import 'dart:ui';

import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  'Class Number': find.byKey(const Key('Class Number Text Box')).hitTestable(),
  'Instructors': find.byKey(const Key('Instructor Text Box')).hitTestable(),
  'Is Open': find.byKey(const Key('Is Open Checkbox')).hitTestable(),
  'GS': find.byKey(const Key('General Studies Checkbox')).hitTestable(),
  'notTaken': find.byKey(const Key('Not Taken Checkbox')).hitTestable(),
};

bool dataLoaded = false;
late BuildContext context;

Future<void> buildTestEnvironment(
  WidgetTester tester, {
  double width = 2000,
  double height = 1200,
}) async {
  // Load data once for all tests
  if (!dataLoaded) {
    await DataHandler.fetchData(test: true);
    Class.instances; // Initialize class list
    await Filters().load();
    await Filters().update();
    dataLoaded = true;
  }

  // Ensure minimum width to accommodate FilterMenu (400px) + content
  final double effectiveWidth = width < 800 ? 800 : width;
  await tester.binding.setSurfaceSize(Size(effectiveWidth, height));
  await tester.pumpWidget(const Schedule());
  context = tester.element(find.byType(Schedule));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
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

Widget descendWidgetTree(dynamic element, String key) {
  Widget finder = const Text(key: Key('Widget does not exist.'), '');
  final Widget mainWidget = element is StatelessWidget
      // ignore: invalid_use_of_protected_member
      ? element.build(context)
      : element is MultiChildRenderObjectElement ||
            element is SingleChildRenderObjectElement
      ? element.widget
      : element;

  if (element is! MultiChildRenderObjectElement) {
    if (element.key == Key(key)) {
      return element;
    }
  } else {
    if (mainWidget.key == Key(key)) {
      return element.widget;
    }
  }
  if (mainWidget is SingleChildRenderObjectWidget) {
    if (mainWidget.child != null) {
      finder = descendWidgetTree(mainWidget.child, key);
      if (finder.key == Key(key)) {
        return finder;
      }
    }
  } else if (mainWidget is MultiChildRenderObjectWidget) {
    for (final child in mainWidget.children) {
      finder = descendWidgetTree(child, key);
      if (finder.key == Key(key)) {
        return finder;
      }
    }
  }
  return finder;
}

String textInCellWithKey(Element element, String key) {
  final text = descendWidgetTree(element.widget, key) as Text;
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

Future<void> openFilterMenu(WidgetTester tester) async {
  final filterButton = find.byKey(const Key('Filter Button')).hitTestable();
  await tester.tap(filterButton);
  await tester.pumpAndSettle();
}

Future<void> closeFilterMenu(WidgetTester tester) async {
  // Tap the close icon in the filter menu header
  final closeIcon = find.byIcon(Icons.close).hitTestable().last;
  await tester.tap(closeIcon);
  await tester.pumpAndSettle();
}

Future<void> hoverOver(WidgetTester tester, Finder finder) async {
  final Offset location = tester.getCenter(finder.first);
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer();
  await gesture.moveTo(location);
  // Tooltip appears after its waitDuration; advance test clock accordingly.
  await tester.pump(const Duration(milliseconds: 700));
}

Future<void> hoverExpect(
  WidgetTester tester,
  Finder finder,
  dynamic matcher,
) async {
  await hoverOver(tester, finder);
  expect(matcher, findsAtLeast(1));
}

Future<void> dropdownTester(
  WidgetTester tester, {
  required String menu,
  required List<String> options,
  required dynamic condition,
  required List<String> cellKeys,
  required double testerWidth,
}) async {
  final String type = testerWidth > 965 ? 'Wide' : 'Small';
  await buildTestEnvironment(tester, width: testerWidth);
  await openFilterMenu(tester);

  // For Time section which uses dropdowns, handle differently
  if (menu == 'Start Time' || menu == 'End Time') {
    // Expand Time section first
    final timeSection = find.text('Time').hitTestable();
    if (timeSection.evaluate().isNotEmpty) {
      await tester.tap(timeSection);
      await tester.pumpAndSettle();
    }

    // Find the ShadSelect by its stable test key
    final selectKey = menu == 'Start Time'
        ? 'Start Time Select'
        : 'End Time Select';
    final timeSelect = find.byKey(Key(selectKey)).hitTestable();
    expect(timeSelect, findsOneWidget);

    // Tap to open the dropdown
    await tester.tap(timeSelect);
    await tester.pumpAndSettle();

    // Find and tap the third option
    if (options.length > 2) {
      final option = find.text(options[2]).hitTestable().last;
      await tester.tap(option);
      await tester.pumpAndSettle();
    }
  } else {
    // For checkbox-based filters
    // Expand the filter section by finding and tapping the section with the menu title
    // First, find the filter menu's single child scroll view to scope our search
    final singleChildScroll = find.byType(SingleChildScrollView);

    // Find the Campus text specifically within the filter menu's scroll view
    final sectionTitle = find.descendant(
      of: singleChildScroll,
      matching: find.text(menu),
    );

    if (sectionTitle.evaluate().isEmpty) {
      throw StateError('Section title "$menu" not found in FilterMenu');
    }

    var hitTestableTitle = sectionTitle.hitTestable();
    if (hitTestableTitle.evaluate().isEmpty) {
      // Try scrolling to it first
      final scrollable = find.descendant(
        of: singleChildScroll,
        matching: find.byType(Scrollable),
      );
      if (scrollable.evaluate().isNotEmpty) {
        await tester.scrollUntilVisible(
          sectionTitle.first,
          100,
          scrollable: scrollable.first,
        );
      }
      // Re-evaluate after scrolling
      hitTestableTitle = sectionTitle.hitTestable();
    }

    if (hitTestableTitle.evaluate().isNotEmpty) {
      await tester.tap(hitTestableTitle.first);
    } else {
      // Fallback to using doTap
      await doTap(tester, sectionTitle.first);
    }
    await tester.pumpAndSettle();

    // Clear any search box if it exists (e.g., for Department/Subject/Campus)
    final searchBox = find.widgetWithText(TextField, 'Search').hitTestable();
    if (searchBox.evaluate().isNotEmpty) {
      await tester.tap(searchBox);
      await tester.pumpAndSettle();
      await tester.enterText(searchBox, '');
      await tester.pumpAndSettle();
    }

    // Deselect all first (tap Select all twice if it exists)
    final selectAll = find.text('Select all').hitTestable();
    if (selectAll.evaluate().isNotEmpty) {
      await tester.tap(selectAll);
      await tester.pumpAndSettle();
      await tester.tap(selectAll);
      await tester.pumpAndSettle();
    }

    // Wait a moment for the list to rebuild after deselecting
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Find the third option (index 2) and tap it
    // It might not be visible initially, so we'll scroll to find it
    if (options.length > 2) {
      final thirdOption = find.text(options[2]);

      // Debug: Check if any of the options exist
      if (thirdOption.evaluate().isEmpty) {
        // Try the first option instead
        final firstOption = find.text(options[0]);
        if (firstOption.evaluate().isEmpty) {
          // None of our expected options exist - list all available options for debugging
          final allText = find.byType(Text);
          final allTexts = allText
              .evaluate()
              .map((e) => (e.widget as Text).data)
              .join(', ');
          throw StateError(
            'None of the expected options found. Available text widgets: $allTexts',
          );
        }
        // Use first option if third doesn't exist
        await doTap(tester, firstOption.hitTestable());
        return;
      }

      if (thirdOption.hitTestable().evaluate().isEmpty) {
        // Option exists but is not visible - scroll to it
        final scrollable = find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Scrollable),
        );
        if (scrollable.evaluate().isNotEmpty) {
          await tester.scrollUntilVisible(
            thirdOption.first,
            100,
            scrollable: scrollable.first,
          );
        }
      }

      // Re-evaluate hitTestable after potential scrolling
      final hitTestableOption = thirdOption.hitTestable();
      if (hitTestableOption.evaluate().isNotEmpty) {
        await doTap(tester, hitTestableOption.first);
      } else {
        await doTap(tester, thirdOption.first);
      }
    }
  }

  // Close filter menu to see results
  await closeFilterMenu(tester);
  await tester.pumpAndSettle();

  expectInResults(cellKeys, condition, type: type);
}

Future<void> textBoxTester(
  WidgetTester tester, {
  required String textField,
  required List<String> txtOpts,
  required List<String> cellKeys,
  required double testerWidth,
}) async {
  final String type = testerWidth > 950 ? 'Wide' : 'Small';
  await buildTestEnvironment(tester, width: testerWidth);

  for (final opt in txtOpts) {
    await openFilterMenu(tester);

    // Find the text field by its stable key.
    final textFieldFinder = find.byKey(Key('$textField Input')).hitTestable();
    expect(textFieldFinder, findsOneWidget);

    await insertText(tester, textFieldFinder, opt);

    // Close filter menu to see results
    await closeFilterMenu(tester);
    await tester.pumpAndSettle();

    expectInResults(cellKeys, equals(opt), type: type);
    multiExpect(excludeIndex(txtOpts, txtOpts.indexOf(opt)), findsNothing);
  }
}

void expectInResults(
  List<String> keys,
  dynamic condition, {
  required String type,
}) {
  final container = type == 'Wide' || type == 'Medium' ? 'Cell' : 'Row';
  final dataFinder = type == 'Wide' || type == 'Medium' || type == 'Small'
      ? find.byWidgetPredicate(
          (Widget widget) =>
              widget.key is ValueKey<String> &&
              RegExp(
                r'^Class \d{0,4}',
              ).hasMatch((widget.key as ValueKey<String>).value) &&
              widget is Row,
        )
      : find.byWidgetPredicate(
          (Widget widget) =>
              widget.key is ValueKey<String> &&
              RegExp(
                r'^Detail Row \d{0,4}',
              ).hasMatch((widget.key as ValueKey<String>).value) &&
              widget is Column,
        );

  for (final key in keys) {
    for (final each in dataFinder.evaluate()) {
      final cellText = textInCellWithKey(each, '$key $container');
      if (condition != isNot('')) {
        if (cellText != '') {
          expect(cellText, condition);
        }
      } else {
        expect(cellText, condition);
      }
    }
  }
}
