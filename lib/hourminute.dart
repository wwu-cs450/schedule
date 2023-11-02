// author:  Ethan Jansen
// date:    2023/10/26
// class:   HourMinute
// details: A 24hr time (hour, minute)
// Notes:
/*
   Will automatically convert time to have hour<24 and minute<60 without warning!
   Throws exception if hour or minute is negative.
*/

class HourMinute implements Comparable<HourMinute> {
  // constructors
  // direct construction (24 hour time)
  HourMinute({int hour = 0, int minute = 0}) {
    if (hour.isNegative || minute.isNegative) {
      throw NegativeTimeException();
    }

    this.hour = (hour + minute ~/ 60) % 24;
    this.minute = minute % 60;
  }

  // construct using DateTime
  HourMinute.fromDate(DateTime date) {
    hour = date.hour;
    minute = date.minute;
  }
  // instance variables
  late int hour, minute;

  // instance methods

  // get HourMinute after Duration dur
  HourMinute add(Duration dur) => HourMinute(
        hour: hour + dur.inHours,
        minute: minute + (dur.inMinutes % 60),
      );

  // get Duration from other HourMinute (this-other)
  Duration durationFrom(HourMinute other) =>
      Duration(hours: hour - other.hour, minutes: minute - other.minute);

  // get string from HourMinute -- if is24hr==null, treat as is24hr=true;
  @override
  String toString({bool? is24hr}) {
    is24hr ??= true;

    if (is24hr) {
      return "$hour:${minute.toString().padLeft(2, '0')}";
    } else {
      return hour > 11
          ? "${hour % 12}:${minute.toString().padLeft(2, '0')}PM"
          : "${hour % 12}:${minute.toString().padLeft(2, '0')}AM";
    }
  }

  @override
  int compareTo(HourMinute other) =>
      ((hour * 60) + minute) - ((other.hour * 60) + other.minute);

  @override
  int get hashCode => ((hour * 60) + minute).hashCode;

  // comparison operators

  bool operator <=(HourMinute other) =>
      (hour * 60) + minute <= (other.hour * 60) + other.minute;
  bool operator <(HourMinute other) =>
      (hour * 60) + minute < (other.hour * 60) + other.minute;
  bool operator >=(HourMinute other) =>
      (hour * 60) + minute >= (other.hour * 60) + other.minute;
  bool operator >(HourMinute other) =>
      (hour * 60) + minute > (other.hour * 60) + other.minute;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HourMinute && hour == other.hour && minute == other.minute);
}

// exceptions
class NegativeTimeException implements Exception {}
