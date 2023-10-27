import 'package:schedule/department.dart';
import 'package:schedule/section.dart';
import 'package:schedule/subject.dart';

class Query {
  final Department? department;
  final Subject? subject;

  Query(this.department, this.subject);

  Set<Section> results() {
    return Section.instances
        .where((each) =>
            (department == null || each.course.department == department) &&
            (subject == null || each.course.subject == subject))
        .toSet();
  }
}
