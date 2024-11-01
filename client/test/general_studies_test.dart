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
}
