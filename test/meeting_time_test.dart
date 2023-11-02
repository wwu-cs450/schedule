// author:  Ethan Jansen
// date:    2023/10/26
// tests:   MeetingTime
// Notes:
/*
   
*/
import 'dart:developer';
import 'package:flutter/foundation.dart'; // need for setEquals -- deep comparison
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule/hourminute.dart';
import 'package:schedule/meeting_time.dart';

void main() {
  test('adding, getting, and removing times', () {
    final MeetingTime test = MeetingTime();
    final HourMinute time1 = HourMinute();
    final HourMinute time2 = HourMinute(hour: 1, minute: 50);
    final HourMinute time3 = HourMinute(hour: 2, minute: 30);
    const Duration dur1 = Duration(hours: 2);

    bool? testBoolean;

    // initally empty
    assert(test.count == 0);

    // try (badly) adding elements
    // negative day
    try {
      testBoolean = test.add(day: -1, start: time1, end: time2);
      log('NegativeTimeException NOT thrown appropriately');
    } catch (e) {
      log('NegativeTimeException thrown appropriately');
      assert(e is NegativeTimeException);
    }
    // start before end
    try {
      testBoolean = test.add(day: 1, start: time2, end: time1);
      log('EndPreceedsStart NOT thrown appropriately');
    } catch (e) {
      log('EndPreceedsStart thrown appropriately');
      assert(e is EndPreceedsStart);
    }

    // try (properly) adding elements
    // add
    testBoolean = test.add(day: DateTime.monday, start: time1, end: time2);
    assert(testBoolean);
    // add something that already exists
    testBoolean = test.add(day: DateTime.monday, start: time1, end: time2);
    assert(!testBoolean);
    // add something with conflict
    testBoolean = test.add(day: DateTime.monday, start: time1, end: time3);
    assert(!testBoolean);
    assert(test.count == 1); // should only add one element

    // addUsingDuration
    testBoolean = test.addUsingDuration(
      day: DateTime.tuesday,
      start: time2,
      length: dur1,
    );
    assert(testBoolean);
    // addUsingDuration -- already exists
    testBoolean = test.addUsingDuration(
      day: DateTime.tuesday,
      start: time2,
      length: dur1,
    );
    assert(!testBoolean);
    // addUsingDuration -- with conflict
    testBoolean = test.addUsingDuration(
      day: DateTime.tuesday,
      start: time3,
      length: dur1,
    );
    assert(!testBoolean);
    assert(test.count == 2); // should only add one additional element

    // check what was added
    assert(test[0] == (day: DateTime.monday, start: time1, end: time2));
    assert(
      test[1] == (day: DateTime.tuesday, start: time2, end: time2.add(dur1)),
    );

    // removing items
    // remove something that doesn't exist
    testBoolean = test.remove(day: DateTime.monday, start: time1, end: time3);
    assert(!testBoolean);
    assert(test.count == 2);
    // remove first time
    testBoolean = test.remove(day: DateTime.monday, start: time1, end: time2);
    assert(testBoolean);
    assert(test.count == 1);
    assert(
      test[0] == (day: DateTime.tuesday, start: time2, end: time2.add(dur1)),
    ); // what was the second element
    // remove the last remaining time
    testBoolean =
        test.remove(day: DateTime.tuesday, start: time2, end: time2.add(dur1));
    assert(testBoolean);
    assert(test.count == 0);
  });

  test('getting info', () {
    final MeetingTime test = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 2, minute: 30);
    final HourMinute time4 = HourMinute(hour: 4, minute: 15);

    Set<({HourMinute start, HourMinute end})> testSet1;
    Set<int> testSet2;
    Duration testDuration;
    ({HourMinute start, HourMinute end})? testTime;

    // adding times
    test.add(day: DateTime.monday, start: time1, end: time2);
    test.add(day: DateTime.monday, start: time2, end: time3);
    test.add(day: DateTime.monday, start: time3, end: time4);
    test.add(day: DateTime.tuesday, start: time1, end: time2);
    test.add(day: DateTime.wednesday, start: time1, end: time2);

    // getPeriodsOnDay
    // only one time
    testSet1 = test.getPeriodsOnDay(DateTime.tuesday);
    assert(testSet1.length == 1);
    assert(setEquals(testSet1, {(start: time1, end: time2)}));
    // three times
    testSet1 = test.getPeriodsOnDay(DateTime.monday);
    assert(testSet1.length == 3);
    assert(
      setEquals(testSet1, {
        (start: time1, end: time2),
        (start: time3, end: time4),
        (start: time2, end: time3),
      }),
    );
    // zero times
    testSet1 = test.getPeriodsOnDay(DateTime.sunday);
    assert(testSet1.isEmpty);

    // getDurationOnDay
    // with three times (all added together)
    testDuration = test.getDurationOnDay(DateTime.monday);
    assert(testDuration == const Duration(hours: 1, minutes: 10 + 30 + 45));
    // with only one time
    testDuration = test.getDurationOnDay(DateTime.wednesday);
    assert(testDuration == const Duration(minutes: 10));
    // zero times
    testDuration = test.getDurationOnDay(DateTime.saturday);
    assert(testDuration == Duration.zero);

    // weeklyDuration
    assert(
      test.weeklyDuration ==
          const Duration(hours: 1, minutes: 10 + 30 + 45 + 20),
    );

    // getDaysAtTime
    // time in the middle of a range
    // only one day
    testSet2 = test.getDaysAtTime(HourMinute(hour: 4));
    assert(testSet2.length == 1);
    assert(setEquals(testSet2, {DateTime.monday}));
    // edge time
    // three days
    testSet2 = test.getDaysAtTime(time1);
    assert(testSet2.length == 3);
    assert(
      setEquals(
        testSet2,
        {DateTime.monday, DateTime.tuesday, DateTime.wednesday},
      ),
    );
    // zero days
    testSet2 = test.getDaysAtTime(HourMinute(hour: 13));
    assert(testSet2.isEmpty);

    // getPeriodOnDayAtTime
    // no period
    testTime = test.getPeriodOnDayAtTime(time: time1, day: DateTime.thursday);
    assert(testTime == null);
    // time at start of period
    testTime = test.getPeriodOnDayAtTime(time: time1, day: DateTime.tuesday);
    assert(testTime == (start: time1, end: time2));
    // time at end of period
    testTime = test.getPeriodOnDayAtTime(time: time4, day: DateTime.monday);
    assert(testTime == null);
    // time in middle of period
    testTime = test.getPeriodOnDayAtTime(
      time: time3.add(const Duration(minutes: 15)),
      day: DateTime.monday,
    );
    assert(testTime == (start: time3, end: time4));

    // isAt
    // null
    assert(test.isAt() == null);
    // day only
    assert(test.isAt(day: DateTime.monday)!); // is at
    assert(!test.isAt(day: DateTime.thursday)!); // is not at
    // time only
    assert(test.isAt(time: HourMinute(hour: 4))!); // in range
    assert(!test.isAt(time: time4)!); // on trailing edge
    assert(
      test.isAt(time: time1)!,
    ); // on leading edge -- multiple matching times
    assert(!test.isAt(time: HourMinute(hour: 22))!); // is not at
    // day and time
    assert(test.isAt(day: DateTime.wednesday, time: time1)!); // both match
    assert(
      !test.isAt(
        day: DateTime.wednesday,
        time: HourMinute(hour: 22),
      )!,
    ); // time doesn't match
    assert(
      !test.isAt(day: DateTime.thursday, time: time1)!,
    ); // day doesn't match
    assert(
      !test.isAt(
        day: DateTime.thursday,
        time: HourMinute(hour: 22),
      )!,
    ); // no match
  });

  test('to string methods', () {
    final MeetingTime test = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 21, minute: 30);
    final HourMinute time4 = HourMinute(hour: 23, minute: 15);

    String? testString;

    // adding times
    test.add(day: DateTime.monday, start: time1, end: time2); // M 1:50 - 2:00
    test.add(day: DateTime.monday, start: time2, end: time3); // M 2:00 - 21:30
    test.add(day: DateTime.monday, start: time3, end: time4); // M 21:30 - 23:15
    test.add(day: DateTime.tuesday, start: time1, end: time2); // T 1:50 - 2:00
    test.add(
      day: DateTime.wednesday,
      start: time1,
      end: time2,
    ); // W 1:50 - 2:00

    // toString
    // like existing ClassOpen - 24hr
    testString = test.toString();
    log(testString);
    assert(testString == 'MTW 1:50 - 2:00\nM 2:00 - 21:30\nM 21:30 - 23:15\n');
    // like existing ClassOpen - 12hr
    testString = test.toString(is24hr: false);
    log(testString);
    assert(
      testString ==
          'MTW 1:50AM - 2:00AM\nM 2:00AM - 9:30PM\nM 9:30PM - 11:15PM\n',
    );

    // toStringExpanded
    // expanded out by day (all on new lines) - 24hr
    testString = test.toStringExpanded();
    log(testString);
    assert(
      testString ==
          'M 1:50 - 2:00\nM 2:00 - 21:30\nM 21:30 - 23:15\nT 1:50 - 2:00\nW 1:50 - 2:00\n',
    );
    // expanded -- 12hr
    testString = test.toStringExpanded(is24hr: false);
    log(testString);
    assert(
      testString ==
          'M 1:50AM - 2:00AM\nM 2:00AM - 9:30PM\nM 9:30PM - 11:15PM\nT 1:50AM - 2:00AM\nW 1:50AM - 2:00AM\n',
    );
  });

  test("comparison between MeetingTime's", () {
    final MeetingTime test1 = MeetingTime();
    final MeetingTime test2 = MeetingTime();
    final MeetingTime test3 = MeetingTime();
    MeetingTime test4 = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 2, minute: 30);
    final HourMinute time4 = HourMinute(hour: 4, minute: 15);

    // adding times
    // test 1
    test1.add(day: DateTime.monday, start: time1, end: time2);
    test1.add(day: DateTime.monday, start: time2, end: time3);
    test1.add(day: DateTime.monday, start: time3, end: time4);
    test1.add(day: DateTime.tuesday, start: time1, end: time2);
    test1.add(day: DateTime.wednesday, start: time1, end: time2);
    // test 2
    test2.add(day: DateTime.monday, start: time3, end: time4);
    test2.add(day: DateTime.tuesday, start: time1, end: time2);
    test2.add(day: DateTime.thursday, start: time1, end: time2);
    // test 3
    test3.add(day: DateTime.thursday, start: time1, end: time2);
    // test 4
    test4 = test3;

    // equality operator & hashCode
    // assigning one the other
    assert(identical(test3, test4));
    assert(test3 == test4);
    assert(test3.hashCode == test4.hashCode);
    // same content
    test4 = MeetingTime()
      ..add(day: DateTime.thursday, start: time1, end: time2);
    assert(!identical(test3, test4));
    assert(test3 == test4);
    assert(test3.hashCode == test4.hashCode);
    // not equal
    assert(test2 != test3);
    assert(test2.hashCode != test3.hashCode);
    // changing to make equal
    test2.remove(day: DateTime.monday, start: time3, end: time4);
    test2.remove(day: DateTime.tuesday, start: time1, end: time2);
    assert(test2 == test3);
    assert(test2.hashCode == test3.hashCode);
    // direct hashcode check
    final int checkHash = (DateTime.monday, time1, time2).hashCode +
        (DateTime.monday, time2, time3).hashCode +
        (DateTime.monday, time3, time4).hashCode +
        (DateTime.tuesday, time1, time2).hashCode +
        (DateTime.wednesday, time1, time2).hashCode;
    assert(test1.hashCode == checkHash);
  });

  test('checkConflict', () {
    final MeetingTime test1 = MeetingTime();
    final MeetingTime test2 = MeetingTime();
    final MeetingTime test3 = MeetingTime();
    final MeetingTime test4 = MeetingTime();
    final MeetingTime test6 = MeetingTime();
    final MeetingTime test7 = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 2, minute: 30);
    final HourMinute time4 = HourMinute(hour: 4, minute: 15);
    final HourMinute time5 = HourMinute(hour: 12, minute: 20);
    final HourMinute time6 = HourMinute(hour: 14);
    final HourMinute time7 = HourMinute(hour: 15, minute: 30);
    final HourMinute time8 = HourMinute(hour: 20, minute: 45);

    ({
      bool doesConflict,
      Set<({int day, HourMinute time})> conflicts
    }) testResults1;
    ({
      bool doesConflict,
      Set<({int day, HourMinute time})> conflicts
    }) testResults2;

    // adding times
    // test 1
    test1.add(day: DateTime.monday, start: time3, end: time4);
    // test 2
    test2.add(day: DateTime.thursday, start: time1, end: time2);
    // test 3
    test3.add(day: DateTime.thursday, start: time1, end: time3);
    // test 4
    test4.add(day: DateTime.thursday, start: time2, end: time4);
    // test 6
    test6
      ..add(day: DateTime.monday, start: time1, end: time3)
      ..add(day: DateTime.thursday, start: time1, end: time3)
      ..add(day: DateTime.monday, start: time5, end: time7)
      ..add(day: DateTime.monday, start: time3, end: time4);
    // test 7
    test7
      ..add(day: DateTime.monday, start: time2, end: time4)
      ..add(day: DateTime.tuesday, start: time1, end: time3)
      ..add(day: DateTime.monday, start: time5, end: time6)
      ..add(day: DateTime.monday, start: time6, end: time8)
      ..add(day: DateTime.tuesday, start: time6, end: time8);
    // test 3 and 4 should ocnflict at time2
    // test 6 and 7 should conflict at time2, time3, time5, time6

    // checkConflict - no conflicts
    // no conflict -- no matches
    testResults1 = test1.checkConflict(test2);
    assert(!testResults1.doesConflict);
    assert(testResults1.conflicts.isEmpty);
    // no conflict -- same times, different days
    testResults1 = test1.checkConflict(test3);
    assert(!testResults1.doesConflict);
    assert(testResults1.conflicts.isEmpty);
    // no conflict -- same day, different times
    testResults1 = test1.checkConflict(test4);
    assert(!testResults1.doesConflict);
    assert(testResults1.conflicts.isEmpty);

    // checkConflict - conflicts
    // exact same
    testResults1 = test1.checkConflict(test1);
    assert(testResults1.doesConflict);
    assert(
      setEquals(
        testResults1.conflicts,
        {(day: DateTime.monday, time: time3)},
      ),
    );
    // offset times
    testResults1 = test3.checkConflict(test4);
    testResults2 = test4.checkConflict(test3);
    assert(testResults1.doesConflict && testResults2.doesConflict);
    assert(setEquals(testResults1.conflicts, testResults2.conflicts));
    assert(
      setEquals(
        testResults1.conflicts,
        {(day: DateTime.thursday, time: time2)},
      ),
    );
    // several conflicts -- also different counts
    testResults1 = test6.checkConflict(test7);
    testResults2 = test7.checkConflict(test6);
    assert(testResults1.doesConflict && testResults2.doesConflict);
    assert(setEquals(testResults1.conflicts, testResults2.conflicts));
    assert(
      setEquals(testResults1.conflicts, {
        (day: DateTime.monday, time: time2),
        (day: DateTime.monday, time: time3),
        (day: DateTime.monday, time: time5),
        (day: DateTime.monday, time: time6),
      }),
    );
  });
}
