import 'package:schedule_client/domain/course.dart';
import 'package:schedule_client/domain/subjects_list.dart';

class Subject implements Comparable {
  Subject(this.code, this.name);
  final String code;
  final String name;

  static var _instances = <Subject>{};

  static Set<Subject> get instances {
    if (_instances.isEmpty) {
      _instances = {AllSubjects(), ...InitializeSubject.initialList()};
    }
    return _instances;
  }

  static Subject subjectWithCode(String code) {
    try {
      return Subject.instances.firstWhere((instance) => instance.code == code);
    } catch (e) {
      // print('Subject with code "$code" not found');
      rethrow;
    }
  }

  bool includesCourse(Course course) {
    return course.subject.code == code;
  }

  static Subject allSubjects() {
    return instances.first;
  }

  @override
  int compareTo(dynamic other) {
    return name.compareTo(other.name);
  }
}

class AllSubjects extends Subject {
  AllSubjects() : super('', 'All Subjects');

  @override
  bool includesCourse(Course course) {
    return true;
  }
}
