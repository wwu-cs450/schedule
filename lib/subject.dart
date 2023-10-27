import 'package:schedule/subjects_list.dart';

class Subject {
  final String code;
  final String name;

  Subject(this.code, this.name);

  static var _instances = <Subject>{};

  static get instances {
    if (_instances.isEmpty) {
      _instances = InitializeSubject.initialList();
    }
    return _instances;
  }
}
