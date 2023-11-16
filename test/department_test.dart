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
  test('department with code for TECH and the stateError for a notFound code',
      () {
    final flag = Department.instances.any(
      (element) => element.code == 'TECH',
    );
    expect(flag, isTrue);
    final techDepartment = Department.departmentwithCode('TECH');
    expect(techDepartment.code, 'TECH');
    expect(techDepartment.name, 'Technology');
    try {
      Department.departmentwithCode('FAKE');
      assert(false);
    } catch (e) {
      expect(e.runtimeType, StateError);
    }
    // expect(() => Department.departmentwithCode('FAKE'), throwsStateError);
  });
}
