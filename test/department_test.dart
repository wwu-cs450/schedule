import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/department.dart';

void main() {
  test('constructor and accessors', () {
    final department = Department('CPTR', 'Computer Science');
    assert(department.code == 'CPTR');
    assert(department.name == 'Computer Science');
  });

  test('instances', () {
    final departments = Department.instances;
    assert(Department.allDepartments().name == 'ALL');
    assert(departments.length == 29);
    assert(
      departments.any(
        (element) => element.code == 'CPTR',
      ),
    );
  });
}
