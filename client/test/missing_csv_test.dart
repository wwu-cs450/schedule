import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'feature_test_functions.dart';

void main() {
  final File dataFile = File('assets/class_data.csv');
  String? originalContent;

  setUp(() async {
    // Save the original content of the file
    if (await dataFile.exists()) {
      originalContent = await dataFile.readAsString();
      // Delete the file
      await dataFile.delete();
    }
  });

  tearDown(() async {
    // Restore the file with the original content
    if (originalContent != null) {
      await dataFile.writeAsString(originalContent!);
    }
  });

  testWidgets('error page', (WidgetTester tester) async {
    await errorViewTest(tester);
  });
}
