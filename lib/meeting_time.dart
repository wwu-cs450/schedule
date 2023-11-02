// author:  Ethan Jansen
// date:    2023/10/26
// class:   MeetingTime
// details: A list of meeting times defined by the day (as int 1-7), and start/stop times (as HourMinute)
// Notes:
/*
   Automatically converts day (if positive) to be within 1-7 wihtout warning!
   Throws NegativeTimeException if day is <0.
   Throws EndPreceedsStart exception if start >= end.
   Throws MeetingTimeOutOfRange exception if index >= count for [] operator.
   Recommended to use DateTime when inputting day.
*/

import 'package:schedule/hourminute.dart';

// A list of meeting times defined by the day (as int 1-7), and start/stop times (as HourMinute)
class MeetingTime {
  // private instance variables
  final List<_AMeetingTime> _meetingTimes = [];
  int _hashCode = 0; // need to update when adding or removing items

  // only default constructor

  // private methods

  // get day letter from day number
  static String _dayLetter(int dayNumber) {
    switch (dayNumber) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'R';
      case DateTime.friday:
        return 'F';
      default: // sunday and saturday -- this never really happens does it?
        return 'S';
    }
  }

  // instance methods

  // add time if it does not already exist and does not conflict with another existing time.
  // Sort when adding. Update hashCode.
  // returns true if time added successfully.
  bool add({
    required int day,
    required HourMinute start,
    required HourMinute end,
  }) {
    final _AMeetingTime newTime =
        _AMeetingTime(start: start, end: end, day: day);
    final bool contains = _meetingTimes.contains(newTime);
    final bool conflicts =
        isAt(day: day, time: start)! || isAt(day: day, time: end)!;
    if (!(contains || conflicts)) {
      _hashCode += newTime.hashCode;
      _meetingTimes.add(newTime);
      _meetingTimes.sort();
    }

    return !(contains || conflicts);
  }

  // add() but get end by using HourMinute add() method
  bool addUsingDuration({
    required int day,
    required HourMinute start,
    required Duration length,
  }) =>
      add(day: day, start: start, end: start.add(length));

  // remove matching time. Update hashCode.
  bool remove({
    required int day,
    required HourMinute start,
    required HourMinute end,
  }) {
    final _AMeetingTime removeTime =
        _AMeetingTime(start: start, end: end, day: day);
    final bool contains = _meetingTimes.remove(removeTime);
    if (contains) {
      _hashCode -= removeTime.hashCode;
    }
    return contains;
  }

  // get number of items in internal list
  int get count => _meetingTimes.length;

  // get items on day in set of (start, end) records.
  Set<({HourMinute start, HourMinute end})> getPeriodsOnDay(int day) =>
      _meetingTimes
          .where((e) => e.day == day)
          .map((e) => (start: e.start, end: e.end))
          .toSet(); // should this return a set or a list?

  // find sum of durations on day
  Duration getDurationOnDay(int day) {
    Duration returnDuration = const Duration();
    for (final time in _meetingTimes.where((e) => e.day == day)) {
      returnDuration += time.duration;
    }
    return returnDuration;
  }

  // find sum of durations for all internal times.
  Duration get weeklyDuration {
    Duration returnDuration = const Duration();
    for (final time in _meetingTimes) {
      returnDuration += time.duration;
    }
    return returnDuration;
  }

  // get set of days (int) that meet during time.
  Set<int> getDaysAtTime(HourMinute time) => _meetingTimes
      .where((e) => e.occursDuring(time))
      .map((e) => e.day)
      .toSet();

  // get start/end of period that contains time on day.
  // returns (null, null) if no period exists.
  ({HourMinute start, HourMinute end})? getPeriodOnDayAtTime({
    required HourMinute time,
    required int day,
  }) {
    // there should only be 1 match
    if (!isAt(day: day, time: time)!) {
      // if no matches
      return null;
    } else {
      final _AMeetingTime returnTime =
          _meetingTimes.firstWhere((e) => e.day == day && e.occursDuring(time));
      return (start: returnTime.start, end: returnTime.end);
    }
  }

  // check if meeting at time, on day, or at time on day. If all null, return null.
  bool? isAt({int? day, HourMinute? time}) {
    if (day == null && time == null) {
      return null;
    } else if (day == null) {
      return _meetingTimes.any((e) => e.occursDuring(time!));
    } else if (time == null) {
      return _meetingTimes.any((e) => e.day == day);
    } else {
      return _meetingTimes.any((e) => e.occursDuring(time) && e.day == day);
    }
  }

  // check if there is a time conflict between this and other.
  // doesConflict is true if there is a conflict.
  // conflicts contains set of days and times when conflicts first occur
  // Example: both on Monday, MeetingTime1 has meeting 1:00-2:00, MeetingTime2 has meeting 1:30-3:00,
  //          MeetingTime1.checkConflict(MeetingTime2) will have a conflict at 1:30,
  //          MeetingTime2.checkConflict(MeetingTime1) will have a conflict at 1:30.
  ({bool doesConflict, Set<({int day, HourMinute time})> conflicts})
      checkConflict(MeetingTime other) {
    final Set<({int day, HourMinute time})> conflicts = {};
    final int maxCount = count > other.count ? count : other.count;

    // check both ways for consistency
    // set with remove duplicates
    for (int i = 0; i < maxCount; i++) {
      if (i < count && other.isAt(day: this[i].day, time: this[i].start)!) {
        // there is a conflict at this start -- add this start
        conflicts.add((day: this[i].day, time: this[i].start));
      }
      if (i < other.count && isAt(day: other[i].day, time: other[i].start)!) {
        // there is a conflict at other start -- add other start
        conflicts.add((day: other[i].day, time: other[i].start));
      }
    }

    return (doesConflict: conflicts.isNotEmpty, conflicts: conflicts);
  }

  @override
  // return string like existing classOpen
  String toString({bool? is24hr}) {
    String returnString = '';

    // create copy list
    final List<_AMeetingTime> meetingTimesCopy = List.of(_meetingTimes);

    // iterate over matched times adding them all as one line in returnString, then move to next line
    late Iterable<_AMeetingTime> times;
    do {
      final _AMeetingTime? selectedMeet = meetingTimesCopy.firstOrNull;
      if (selectedMeet == null) {
        //check if _meetingTimes is empty
        break;
      }
      times = meetingTimesCopy.where(
        (e) => e.sameTimes(selectedMeet),
      ); // times with same matching time

      // adding to string
      for (final _AMeetingTime time in times) {
        returnString += _dayLetter(time.day);
      }
      returnString +=
          ' ${times.first.start.toString(is24hr: is24hr)} - ${times.first.end.toString(is24hr: is24hr)}\n';

      // remove times from meetingTimesCopy
      meetingTimesCopy.removeWhere((e) => times.contains(e));
    } while (meetingTimesCopy.isNotEmpty);

    return returnString;
  }

  // return string expanded so that every internal time is on separate line.
  String toStringExpanded({bool? is24hr}) {
    String returnString = '';

    for (final time in _meetingTimes) {
      returnString +=
          '${_dayLetter(time.day)} ${time.start.toString(is24hr: is24hr)} - ${time.end.toString(is24hr: is24hr)}\n';
    }

    return returnString;
  }

  // [] operator
  // throws MeetingTimeOutOfRange if index >= count.
  ({int day, HourMinute start, HourMinute end}) operator [](int index) {
    if (index >= count) {
      throw MeetingTimeOutOfRange();
    }
    final _AMeetingTime time = _meetingTimes[index];

    return (day: time.day, start: time.start, end: time.end);
  }

  @override
  // equality operator
  bool operator ==(Object other) {
    if (identical(this, other)) {
      // if identical
      return true;
    } else if (!(other is MeetingTime && count == other.count)) {
      // if not MeetingTime, or does not have the same count
      return false;
    }

    for (int i = 0; i < count; i++) {
      if (this[i] != other[i]) {
        // each record is equal
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => _hashCode;
}

// ------------------------ private class -------------------------------

// defines day (as int), start and stop times (as HourMinute)
class _AMeetingTime implements Comparable<_AMeetingTime> {
  // constructors

  // follows DateTime class (1 is monday, 7 is sunday)
  // throws EndPreceedsStart exception if start >= end
  // throws NegativeTimeException if day < 0.
  _AMeetingTime({required this.start, required this.end, required int day}) {
    if (day < 0) {
      throw NegativeTimeException();
    }
    this.day = ((day - 1) % 7) + 1;

    if (start >= end) {
      throw EndPreceedsStart();
    }
  }
  // instance variables
  HourMinute start, end;
  late int day;

  // instance methods

  // checks if time is within _AMeetingTime
  // inclusivity: [start, end)
  bool occursDuring(HourMinute time) => time >= start && time < end;

  // checks if start and stop time are the same (doesn't care about day)
  bool sameTimes(_AMeetingTime other) =>
      start == other.start && end == other.end;

  // get duration between start and stop
  Duration get duration => end.durationFrom(start);

  @override
  // necessary for sorting in list
  // negative if this is ordered before other
  int compareTo(_AMeetingTime other) {
    if (this == other) {
      return 0;
    }

    // negative if respective time for this occurs before other
    final int compareStarts =
        ((day * 1440) + (start.hour * 60) + start.minute) -
            ((other.day * 1440) + (other.start.hour * 60) + other.start.minute);
    final int compareEnds = ((day * 1440) + (end.hour * 60) + end.minute) -
        ((other.day * 1440) + (other.end.hour * 60) + other.end.minute);

    if (compareStarts == 0) {
      return compareEnds;
    } else {
      return compareStarts;
    }
  }

  @override
  int get hashCode => (day, start, end).hashCode; // are these unique?

  // equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _AMeetingTime &&
          day == other.day &&
          start == other.start &&
          end == other.end);
}

// ---------------- exceptions -------------------
class EndPreceedsStart implements Exception {}

class MeetingTimeOutOfRange implements Exception {}
