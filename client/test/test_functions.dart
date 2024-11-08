import 'dart:ui';

import 'package:client/main.dart';
import 'package:client/views/search_criteria.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  'Status': find.byKey(const Key('Status Checkbox')).hitTestable(),
  'GS': find.byKey(const Key('GS Checkbox')).hitTestable(),
};

late BuildContext context;

Future<void> buildTestEnvironment(WidgetTester tester, double width) async {
  await tester.binding.setSurfaceSize(Size(width, 1000));
  await tester.pumpWidget(const MyApp());
  context = tester.element(find.byType(MyApp));
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

Future<void> openDrawer(WidgetTester tester) async {
  final ScaffoldState state = tester.firstState(find.byType(Scaffold));
  state.openDrawer();
  await tester.pumpAndSettle();
}

Future<void> closeDrawer(WidgetTester tester) async {
  final ScaffoldState state = tester.firstState(find.byType(Scaffold));
  state.closeDrawer();
  await tester.pumpAndSettle();
}

Future<void> hoverOver(WidgetTester tester, Finder finder) async {
  final Offset location = tester.getCenter(finder.first);
  final PointerHoverEvent event = PointerHoverEvent(
    kind: PointerDeviceKind.touch,
    position: location,
  );
  tester.binding.dispatchEvent(event, HitTestResult());
  await tester.pumpAndSettle();
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
  await buildTestEnvironment(tester, testerWidth);
  final ddownOpts = options.map((e) => find.text(e).hitTestable()).toList();
  await openDrawer(tester);
  expect(find.byKey(Key('$menu Dropdown')), findsOneWidget);
  multiExpect(ddownOpts, findsNothing);
  await doTap(tester, finders[menu]!);
  multiExpect(ddownOpts, findsOneWidget);
  for (int i = 1; i < options.length; i++) {
    final option = options[i];
    final delimiter = option.contains(' ') ? ' ' : ':';
    await tester.enterText(finders[menu]!, option.split(delimiter)[0]);
    await tester.pumpAndSettle();
    expect(find.text(options[i]).hitTestable(), findsOneWidget);
    expect(find.text(options[0]).hitTestable(), findsNothing);
    await tester.enterText(finders[menu]!, '');
    await tester.pumpAndSettle();
  }
  await doTap(tester, ddownOpts[2]);
  expect(ddownOpts[2], findsOneWidget);
  multiExpect(excludeIndex(ddownOpts, 2), findsNothing);
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
  await buildTestEnvironment(tester, testerWidth);
  await openDrawer(tester);
  // multiExpect(txtOpts, findsNothing);
  for (final opt in txtOpts) {
    await insertText(tester, finders[textField]!, opt);
    expectInResults(cellKeys, equals(opt), type: type);
    multiExpect(
      excludeIndex(txtOpts, txtOpts.indexOf(opt)),
      findsNothing,
    );
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
              RegExp(r'^Class \d{0,4}')
                  .hasMatch((widget.key as ValueKey<String>).value) &&
              widget is Row,
        )
      : find.byWidgetPredicate(
          (Widget widget) =>
              widget.key is ValueKey<String> &&
              RegExp(r'^Detail Row \d{0,4}')
                  .hasMatch((widget.key as ValueKey<String>).value) &&
              widget is Column,
        );
  for (final key in keys) {
    for (final each in dataFinder.evaluate()) {
      if (condition != isNot('')) {
        if (textInCellWithKey(each, '$key $container') != '') {
          expect(textInCellWithKey(each, '$key $container'), condition);
        }
      } else {
        expect(textInCellWithKey(each, '$key $container'), condition);
      }
    }
  }
}
