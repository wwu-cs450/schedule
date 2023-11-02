import 'package:schedule/department.dart';
import 'package:schedule/section.dart';
import 'package:schedule/subject.dart';

class Query {
  Query(this.department, this.subject);
  final Department? department;
  final Subject? subject;

  Set<Section> results() {
    return Section.instances
        .where(
          (each) =>
              (department == null || each.course.department == department) &&
              (subject == null || each.course.subject == subject),
        )
        .toSet();
  }
}
