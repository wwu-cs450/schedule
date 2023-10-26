import 'package:schedule/departments_list.dart';

class Department {
  final String code;
  final String name;

  Department(this.code, this.name);

  static var _instances = <Department>{};

  static get instances {
    if (_instances.isEmpty) {
      _instances = InitializeDepartment.initialList();
    }
    return _instances;
  }
}
