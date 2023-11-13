import 'package:schedule/department.dart';
import 'package:schedule/class.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';
import 'package:schedule/campus.dart';

class Query {
  Query(this._department, this._subject, this._term, this._campus);
  final Department _department;
  final Subject _subject;
  final Term _term;
  final Campus _campus;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) &&
              _subject.includesCourse(each.course) &&
              _term.includesClass(each) &&
              _campus.includesClass(each),
        )
        .toSet();
  }
}
