import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/department.dart';

void main() {
  test('constructor and accessors', () {
    var department = Department('CPTR', 'Computer Science');
    assert(department.code == 'CPTR');
    assert(department.name == 'Computer Science');
  });

  test('instances', () {
    var departments = Department.instances;
    assert(departments.length == 7);
    assert(departments.any(
      (element) => element.code == 'CPTR',
    ));
  });
}
