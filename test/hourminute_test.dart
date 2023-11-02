// author:  Ethan Jansen
// date:    2023/10/26
// tests:   HourMinute
// Notes:
/*
   
*/

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/hourminute.dart';

void main() {
  test('constructor and accessors', () {
    // constructors
    // default
    final HourMinute time1 = HourMinute(); // 0:00
    // simple: hour and minute defined
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20
    // hour>23
    final HourMinute time3 = HourMinute(hour: 31, minute: 30); // 7:30
    // hour>23, minute>60 (extra minutes should add to hour)
    final HourMinute time4 = HourMinute(hour: 32, minute: 66); // 9:06
    // using DateTime
    final HourMinute time5 =
        HourMinute.fromDate(DateTime(2023, 5, 5, 13, 30, 50)); // 13:30
    // negative numbers -- should throw exception
    try {
      final HourMinute time6 = HourMinute(hour: -1, minute: -99);
      log('exception not caught because ${time6.toString()}');
    } catch (e) {
      log('Successfully caught thrown exception');
      assert(e is NegativeTimeException);
    }

    // accessors
    assert(time1.hour == 0 && time1.minute == 0);
    assert(time2.hour == 6 && time2.minute == 20);
    assert(time3.hour == 7 && time3.minute == 30);
    assert(time4.hour == 9 && time4.minute == 6);
    assert(time5.hour == 13 && time5.minute == 30);

    // adjust time
    time1.minute = 23;
    time1.hour = 10;
    assert(time1.hour == 10 && time1.minute == 23);
  });

  test('durations', () {
    final HourMinute time1 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20

    // get time after duration
    // no change
    HourMinute testTime = time2.add(const Duration(days: 1));
    assert(testTime.hour == time2.hour && testTime.minute == time2.minute);
    // change without rolling over
    testTime = time2.add(const Duration(hours: 5, minutes: 30));
    assert(testTime.hour == 11 && testTime.minute == 50);
    // change with rolling over
    testTime = time2.add(const Duration(hours: 23, minutes: 110));
    assert(testTime.hour == 7 && testTime.minute == 10);

    // get duration between times
    // positive duration
    Duration testDur = time2.durationFrom(time1);
    assert(testDur == const Duration(hours: 5, minutes: 10));
    // negative duration
    testDur = time1.durationFrom(time2);
    assert(testDur == const Duration(hours: -5, minutes: -10));
  });

  test('toString', () {
    final HourMinute time1 = HourMinute(hour: 13, minute: 10); // 13:10
    final HourMinute time2 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time3 = HourMinute(hour: 1, minute: 1); // 1:01

    // 24hr - test 1
    assert(time1.toString() == '13:10');
    // 24hr - test 2
    assert(time1.toString(is24hr: true) == '13:10');
    // 12hr - test 1
    assert(time1.toString(is24hr: false) == '1:10PM');
    // 12hr - test 2
    assert(time2.toString(is24hr: false) == '1:10AM');
    // correct padding
    assert(time3.toString(is24hr: false) == '1:01AM');
  });

  test('comparisons', () {
    final HourMinute time1 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20

    // compareTo
    assert(time1.compareTo(time2) < 0);
    assert(time2.compareTo(time1) > 0);
    assert(time1.compareTo(time1) == 0);

    // hashcode
    assert(time1.hashCode == 70.hashCode);

    // comparison operators
    assert(time1 < time2);
    assert(time1 <= time2);
    assert(time1 == time1);
    assert(time1 <= time1);
    assert(time2 > time1);
    assert(time2 >= time1);
    assert(time1 >= time1);
  });
}
