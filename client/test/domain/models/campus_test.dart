import 'package:client/domain/campus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    final campus = Campus('PD', 'Portland');
    expect(campus.code, 'PD');
    expect(campus.name, 'Portland');
  });

  test('instances', () {
    final campuses = Campus.instances;
    expect(Campus.allCampuses().name, 'All Campuses');
    expect(campuses.length, 13);
    expect(campuses.any((element) => element.code == 'PD'), isTrue);
  });
}
