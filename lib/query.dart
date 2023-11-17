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
    bool?
        includeSpecialTimes, // ARR and '' (class with specified time AND ARR will be included regardless)
    Set<int>? days,
  }) {
    _department = department ?? Department.instances.first;
    _subject = subject ?? Subject.instances.first;
    _term = term ?? Term.instances.first;
    _campus = campus ?? Campus.instances.first;
    _times = times;
    times == null && days == null
        ? _includeSpecialTimes = includeSpecialTimes ?? true
        : _includeSpecialTimes = false;
    _days = days;
  }

  late final Department _department;
  late final Subject _subject;
  late final Term _term;
  late final Campus _campus;
  late final ({HourMinute start, HourMinute end})? _times;
  late final bool _includeSpecialTimes;
  late final Set<int>? _days;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) && //department
              _subject.includesCourse(each.course) && // course
              _term.includesClass(each) && // term
              _campus.includesClass(each) && // campus
              ((_includeSpecialTimes &&
                      (each.schedule.isEmpty || each.schedule.isARR)) ||
                  each.schedule
                      .checkConflict(
                        MeetingTime()
                          ..addSeveralDays(
                            days: _days,
                            start: _times?.start,
                            end: _times?.end,
                          ),
                      )
                      .doesConflict),
        )
        .toSet();
  }
}
