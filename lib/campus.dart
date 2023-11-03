import 'package:schedule/campus_list.dart';

class Campus {
  Campus(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Campus>{};

  static Set<Campus> get instances {
    if (_instances.isEmpty) {
      _instances = InitializeCampus.initialList();
    }
    return _instances;
  }
}
