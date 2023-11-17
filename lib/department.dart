import 'package:schedule/departments_list.dart';
import 'package:schedule/course.dart';

class Department {
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

  static Department departmentwithCode(String code) {
    final departmentOfCode =
        Department._instances.firstWhere((instance) => instance.code == code);

    return departmentOfCode;
  }

  bool includesCourse(Course course) {
    return course.department == this;
  }

  static Department allDepartments() {
    return instances.first;
  }
}

class AllDepartments extends Department {
  AllDepartments() : super('', 'ALL');

  @override
  bool includesCourse(Course course) {
    return true;
  }
}
