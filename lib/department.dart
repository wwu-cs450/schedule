import 'package:schedule/departments_list.dart';

class Department {
  Department(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Department>{};

  static Set<Department> get instances {
    if (_instances.isEmpty) {
      _instances = InitializeDepartment.initialList();
    }
    return _instances;
  }
}
