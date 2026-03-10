import 'package:client/domain/department.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    final department = Department('CPTR', 'Computer Science');
    expect(department.code, 'CPTR');
    expect(department.name, 'Computer Science');
  });

  test('instances', () {
    final departments = Department.instances;
    expect(Department.allDepartments().name, 'All Departments');
    expect(departments.length, 30);
    expect(departments.any((element) => element.code == 'CPTR'), true);
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
