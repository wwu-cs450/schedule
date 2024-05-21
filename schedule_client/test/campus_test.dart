import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/campus.dart';

void main() {
  test('constructor and accessors', () {
    final campus = Campus('PD', 'Portland');
    assert(campus.code == 'PD');
    assert(campus.name == 'Portland');
  });

  test('instances', () {
    final campuses = Campus.instances;
    assert(Campus.allCampuses().name == 'All Campuses');
    assert(campuses.length == 9);
    assert(
      campuses.any(
        (element) => element.code == 'PD',
      ),
    );
  });
}
