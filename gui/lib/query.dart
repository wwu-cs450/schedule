import 'package:gui/campus.dart';
import 'package:gui/class.dart';
import 'package:gui/department.dart';
import 'package:gui/hourminute.dart';
import 'package:gui/meeting_time.dart';
import 'package:gui/subject.dart';
import 'package:gui/term.dart';

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
    int classNumber = 0,
    String level = '',
    String credits = '',
    bool gs = false,
    bool status = false,
    String? instructor,
    List<String> scheduledDays = const <String>[],
    HourMinute? startTime,
    HourMinute? endTime,
  }) {
    _department = department ?? Department.allDepartments();
    _subject = subject ?? Subject.allSubjects();
    _term = term ?? Term.allTerms();
    _campus = campus ?? Campus.allCampuses();
    _times = times;
    times == null && days == null
        ? _includeSpecialTimes = includeSpecialTimes ?? true
        : _includeSpecialTimes = false;
    _days = days;
    _classNumber = classNumber;
    _level = level;
    _credits = credits;
    _gs = gs;
    _status = status;
    _instructor = instructor ?? '';
    _scheduledDays = scheduledDays;
    _startTime = startTime;
    _endTime = endTime;
  }

  late final Department _department;
  late final Subject _subject;
  late final Term _term;
  late final Campus _campus;
  late final ({HourMinute start, HourMinute end})? _times;
  late final bool _includeSpecialTimes;
  late final Set<int>? _days;
  late final int _classNumber;
  late final String _level;
  late final String _credits;
  late final bool _gs;
  late final bool _status;
  late final String _instructor;
  late final List<String> _scheduledDays;
  late final HourMinute? _startTime;
  late final HourMinute? _endTime;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              _department.includesCourse(each.course) && //department
              _subject.includesCourse(each.course) && // course
              _term.includesClass(each) && // term
              _campus.includesClass(each) && // campus
              each.includesLevel(_level) && // level
              each.includesCredits(_credits) &&
              each.includesGS(_gs) &&
              each.includesOpen(_status) &&
              each.includesInstructor(_instructor) &&
              each.includesDays(_scheduledDays) &&
              each.includesStartTime(_startTime) &&
              each.includesEndTime(_endTime) &&
              (_classNumber == 0 || _classNumber == each.classNumber) &&
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
