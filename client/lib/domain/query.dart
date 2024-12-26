import 'package:client/domain/class.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/meeting_time.dart';

class Query {
  Query({
    required this.searchCriteria,
    ({HourMinute start, HourMinute end})? times,
    // ARR and '' (class with specified time AND ARR will be included regardless)
    bool? includeSpecialTimes,
    Set<int>? days,
  }) {
    _scheduledDays = searchCriteria.schedule;
    _times = times;
    times == null && days == null
        ? _includeSpecialTimes = includeSpecialTimes ?? true
        : _includeSpecialTimes = false;
    _days = days;
  }

  Filters searchCriteria;
  late final ({HourMinute start, HourMinute end})? _times;
  late final bool _includeSpecialTimes;
  late final Set<int>? _days;
  late final List<String> _scheduledDays;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              searchCriteria.department
                  .includesCourse(each.course) && //department
              searchCriteria.subject.includesCourse(each.course) && // course
              searchCriteria.term.includesClass(each) && // term
              searchCriteria.campus.includesClass(each) && // campus
              each.includesLevel(searchCriteria.level) && // level
              each.includesCredits(searchCriteria.credits) &&
              each.includesGS(searchCriteria.isGS) &&
              each.includesOpen(searchCriteria.isOpen) &&
              each.includesNotTaken(searchCriteria.isNotTaken) &&
              each.includesInstructor(searchCriteria.instructor) &&
              each.includesDays(_scheduledDays) &&
              each.includesStartTime(searchCriteria.startTime) &&
              each.includesEndTime(searchCriteria.endTime) &&
              (searchCriteria.classNumber == 0 ||
                  searchCriteria.classNumber == each.classNumber) &&
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
