import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/campus.dart';

void main() {
  test('constructor and accessors', () {
    var campus = Campus('PD', 'Portland');
    assert(campus.code == 'PD');
    assert(campus.name == 'Portland');
  });

  test('instances', () {
    var campuses = Campus.instances;
    assert(campuses.length == 3);
    assert(campuses.any(
      (element) => element.code == 'PD',
    ));
  });
}
