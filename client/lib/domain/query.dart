import 'package:client/domain/class.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/meeting_time.dart';

class Query {
  Query({
    ({HourMinute start, HourMinute end})? times,
    // ARR and '' (class with specified time AND ARR will be included regardless)
    bool? includeSpecialTimes,
    Set<int>? days,
  }) {
    _searchCriteria = Filters();
    _scheduledDays = _searchCriteria.schedule;
    _times = times;
    times == null && days == null
        ? _includeSpecialTimes = includeSpecialTimes ?? true
        : _includeSpecialTimes = false;
    _days = days;
  }

  late Filters _searchCriteria;
  late final ({HourMinute start, HourMinute end})? _times;
  late final bool _includeSpecialTimes;
  late final Set<int>? _days;
  late final List<String> _scheduledDays;

  Set<Class> results() {
    return Class.instances
        .where(
          (each) =>
              (_searchCriteria.departments.isEmpty ||
                  _searchCriteria.departments.any(
                    (dept) => dept.includesCourse(each.course),
                  )) && //department
              (_searchCriteria.subjects.isEmpty ||
                  _searchCriteria.subjects.any(
                    (subj) => subj.includesCourse(each.course),
                  )) && // subject
              _searchCriteria.term.includesClass(each) && // term
              (_searchCriteria.campuses.isEmpty ||
                  _searchCriteria.campuses.any(
                    (campus) => campus.includesClass(each),
                  )) && // campus
              each.includesLevels(_searchCriteria.levels) && // level
              each.includesCreditsFromList(_searchCriteria.credits) &&
              each.includesGS(_searchCriteria.isGS) &&
              each.includesGeneralCategories(
                _searchCriteria.generalCategories,
              ) &&
              each.includesOpen(_searchCriteria.isOpen) &&
              each.includesNotTaken(_searchCriteria.isNotTaken) &&
              each.includesNoConflict(_searchCriteria.isHideConflicting) &&
              each.includesInstructor(_searchCriteria.instructor) &&
              each.includesDays(
                _scheduledDays,
                logic: _searchCriteria.scheduleLogic,
              ) &&
              each.includesStartTime(_searchCriteria.startTime) &&
              each.includesEndTime(_searchCriteria.endTime) &&
              (_searchCriteria.classNumber == 0 ||
                  _searchCriteria.classNumber == each.classNumber) &&
              ((_times == null &&
                      _days == null &&
                      (_includeSpecialTimes ||
                          !(each.schedule.isEmpty || each.schedule.isARR))) ||
                  ((_times != null || _days != null) &&
                      ((_includeSpecialTimes &&
                              (each.schedule.isEmpty || each.schedule.isARR)) ||
                          each.schedule
                              .checkConflict(
                                MeetingTime()..addSeveralDays(
                                  days: _days,
                                  start: _times?.start,
                                  end: _times?.end,
                                ),
                              )
                              .doesConflict))),
        )
        .toSet();
  }
}
