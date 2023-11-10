import 'package:schedule/department.dart';
import 'package:schedule/class.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';

class Query {
  Query(this._department, this._subject, this._term);
  final Department _department;
  final Subject _subject;
  final Term _term;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) &&
              _subject.includesCourse(each.course) &&
              _term.includesClass(each),
        )
        .toSet();
  }
}
