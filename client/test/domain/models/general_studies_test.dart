import 'package:client/domain/general_studies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GeneralStudies categories count', () {
    // Access categories
    final categories = GeneralStudies.all;

    expect(
      categories.length,
      17,
      reason: 'The number of categories should be 17.',
    );
  });

  test('findCategory finds correct category for a known course', () {
    final category = GeneralStudies.findCategory('ENGL 121: College Writing I');
    expect(category?.trim(), 'Written Comm & Information Literacy (6)');
  });

  test('findCategory returns null for nonexistent course', () {
    final category = GeneralStudies.findCategory('Nonexistent Course');
    expect(category, isNull, reason: 'return null for non existent course.');
  });
}
