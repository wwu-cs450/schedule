import 'package:client/domain/course.dart';
import 'package:client/domain/departments_list.dart';

class Department implements Comparable {
  Department(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Department>{};

  static Set<Department> get instances {
    if (_instances.isEmpty) {
      _instances = {AllDepartments(), ...InitializeDepartment.initialList()};
    }
    return _instances;
  }

  static Department departmentWithCode(String code) {
    try {
      final departmentOfCode = Department.instances.firstWhere(
        (instance) => instance.code == code,
      );
      return departmentOfCode;
    } catch (e) {
      // print('Department "$code" not found!');
      rethrow;
    }
  }

  static Department fromCode(String code) {
    return instances.firstWhere((department) => department.code == code);
  }

  bool includesCourse(Course course) {
    return course.department == this;
  }

  static Department allDepartments() {
    return instances.first;
  }

  @override
  int compareTo(dynamic other) {
    return name.compareTo(other.name);
  }
}

class AllDepartments extends Department {
  AllDepartments() : super('', 'All Departments');

  @override
  bool includesCourse(Course course) {
    return true;
  }
}
