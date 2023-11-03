import 'package:schedule/department.dart';
import 'package:schedule/class.dart';
import 'package:schedule/subject.dart';

class Query {
  Query(this._department, this._subject);
  final Department _department;
  final Subject? _subject;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) &&
              (_subject == null || each.course.subject == _subject),
        )
        .toSet();
  }
}
