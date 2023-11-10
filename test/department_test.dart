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
    assert(departments.length == 29);
    assert(
      departments.any(
        (element) => element.code == 'CPTR',
      ),
    );
  });
  test('department with code for TECH and the default CPTR', () {
    final techDepartment = Department.departmentwithCode('TECH');
    final fakeDepartment = Department.departmentwithCode('FAKE');
    expect(techDepartment.code, 'TECH');
    expect(techDepartment.name, 'Technology');
    expect(fakeDepartment.code, 'CPTR');
    expect(fakeDepartment.name, 'Computer Science');
  });
}
