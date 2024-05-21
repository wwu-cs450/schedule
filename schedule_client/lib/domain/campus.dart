import 'package:schedule_client/domain/campus_list.dart';
import 'package:schedule_client/domain/class.dart';

class Campus implements Comparable {
  Campus(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Campus>{};

  static Set<Campus> get instances {
    if (_instances.isEmpty) {
      _instances = {AllCampuses(), ...InitializeCampus.initialList()};
    }
    return _instances;
  }

  bool includesClass(Class classInstance) {
    return classInstance.campus == this;
  }

  static Campus allCampuses() {
    return instances.first;
  }

  @override
  int compareTo(dynamic other) {
    return name.compareTo(other.name);
  }
}

class AllCampuses extends Campus {
  AllCampuses() : super('', 'All Campuses');

  @override
  bool includesClass(Class classInstance) {
    return true;
  }
}
