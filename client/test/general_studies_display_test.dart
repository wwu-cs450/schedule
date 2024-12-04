import 'package:client/domain/general_studies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneralStudies', () {
    setUpAll(() {
      GeneralStudies.all;
    });

    test('findCategory returns correct category for a valid course', () {
      expect(
        GeneralStudies.findCategory('ENGL 121: College Writing I')?.trim(),
        'Written Comm & Information Literacy (6)',
      );
      expect(
        GeneralStudies.findCategory('HIST 121: West & the World')?.trim(),
        'History (Choose one)',
      );
      expect(
        GeneralStudies.findCategory('PHIL 204: Critical Reasoning')?.trim(),
        'Humanities (Choose one)',
      );
    });

    test('findCategory returns null for an invalid course', () {
      expect(GeneralStudies.findCategory('Nonexistent Course'), isNull);
    });
  });
}
