import 'package:client/domain/department.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    final department = Department('CPTR', 'Computer Science');
    assert(department.code == 'CPTR');
    assert(department.name == 'Computer Science');
  });

  test('instances', () {
    final departments = Department.instances;
    assert(Department.allDepartments().name == 'All Departments');
    assert(departments.length == 30);
    assert(departments.any((element) => element.code == 'CPTR'));
  });

  test(
    'department with code for TECH and the stateError for a notFound code',
    () {
      final techDepartment = Department.departmentWithCode('TECH');
      expect(techDepartment.code, 'TECH');
      expect(techDepartment.name, 'Technology');
      Object? ex;
      try {
        Department.departmentWithCode('FAKE');
      } catch (e) {
        ex = e;
      }
      expect(ex.runtimeType, StateError);
    },
  );
}
