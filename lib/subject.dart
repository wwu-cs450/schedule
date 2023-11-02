import 'package:schedule/subjects_list.dart';

class Subject {
  Subject(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Subject>{};

  static Set<Subject> get instances {
    if (_instances.isEmpty) {
      _instances = InitializeSubject.initialList();
    }
    return _instances;
  }
}
