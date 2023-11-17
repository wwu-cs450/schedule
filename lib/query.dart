import 'package:schedule/department.dart';
import 'package:schedule/class.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';
import 'package:schedule/hourminute.dart';
import 'package:schedule/meeting_time.dart';
import 'package:schedule/campus.dart';

class Query {
  Query({
    Department? department,
    Subject? subject,
    Term? term,
    Campus? campus,
    ({HourMinute start, HourMinute end})? times,
    int? day,
  }) {
    _department = department ?? Department.instances.first;
    _subject = subject ?? Subject.instances.first;
    _term = term ?? Term.instances.first;
    _campus = campus ?? Campus.instances.first;
    _times = times;
    _day = day;
  }

  late final Department _department;
  late final Subject _subject;
  late final Term _term;
  late final Campus _campus;
  late final ({HourMinute start, HourMinute end})? _times;
  late final int? _day;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) &&
              _subject.includesCourse(each.course) &&
              _term.includesClass(each) &&
              _campus.includesClass(each) &&
              (each.schedule
                  .checkConflict(
                    MeetingTime()
                      ..add(day: _day, start: _times?.start, end: _times?.end),
                  )
                  .doesConflict),
        )
        .toSet();
  }
}
