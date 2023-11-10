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
    final toSearch = instances;
    for (final instance in toSearch) {
      if (instance.code == code) {
        return instance;
      }
    }
    return Department('CPTR', 'Computer Science');
  }

  bool includesCourse(Course course) {
    return course.department == this;
  }
}

class AllDepartments extends Department {
  AllDepartments() : super('', 'ALL');

  @override
  bool includesCourse(Course course) {
    return true;
  }
}
