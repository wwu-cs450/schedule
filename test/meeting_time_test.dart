// author:  Ethan Jansen
// date:    2023/10/26
// tests:   MeetingTime
// Notes:
/*
   
*/
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

    // initally empty
    expect(test, hasLength(0));
    expect(test, isEmpty);

    // try (badly) adding elements
    // negative day
    expect(
      () => test.add(day: -1, start: time1, end: time2),
      throwsA(isA<NegativeTimeException>()),
    );
    // start before end
    expect(
      () => test.add(day: 1, start: time2, end: time1),
      throwsA(isA<EndPreceedsStart>()),
    );

    // properly adding elements
    // add
    expect(test.add(day: DateTime.monday, start: time1, end: time2), isTrue);
    // add something that already exists
    expect(test.add(day: DateTime.monday, start: time1, end: time2), isFalse);
    // add something with conflict
    expect(test.add(day: DateTime.monday, start: time1, end: time3), isFalse);
    expect(test, hasLength(1)); // should have only added one element
    expect(test, isNotEmpty);

    // addUsingDuration
    expect(
      test.addUsingDuration(
        day: DateTime.tuesday,
        start: time2,
        length: dur1,
      ),
      isTrue,
    );
    // addUsingDuration -- already exists
    expect(
      test.addUsingDuration(
        day: DateTime.tuesday,
        start: time2,
        length: dur1,
      ),
      isFalse,
    );
    // addUsingDuration -- with conflict
    expect(
      test.addUsingDuration(
        day: DateTime.tuesday,
        start: time3,
        length: dur1,
      ),
      isFalse,
    );
    expect(test, hasLength(2)); // should only add one additional element

    // check what was added
    expect(test[0], (day: DateTime.monday, start: time1, end: time2));
    expect(
      test[1],
      (day: DateTime.tuesday, start: time2, end: time2.add(dur1)),
    );

    // removing items
    // remove something that doesn't exist
    expect(
      test.remove(day: DateTime.monday, start: time1, end: time3),
      isFalse,
    );
    expect(test, hasLength(2));
    // remove first time
    expect(test.remove(day: DateTime.monday, start: time1, end: time2), isTrue);
    expect(test, hasLength(1));
    expect(
      test[0],
      (day: DateTime.tuesday, start: time2, end: time2.add(dur1)),
    ); // what was the second element
    // remove the last remaining time
    expect(
      test.remove(day: DateTime.tuesday, start: time2, end: time2.add(dur1)),
      isTrue,
    );
    expect(test, isEmpty);
  });

  test('getting info', () {
    final MeetingTime test = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 2, minute: 30);
    final HourMinute time4 = HourMinute(hour: 4, minute: 15);

    // adding times
    test.add(day: DateTime.monday, start: time1, end: time2);
    test.add(day: DateTime.monday, start: time2, end: time3);
    test.add(day: DateTime.monday, start: time3, end: time4);
    test.add(day: DateTime.tuesday, start: time1, end: time2);
    test.add(day: DateTime.wednesday, start: time1, end: time2);

    // getPeriodsOnDay
    // only one time
    expect(
      test.getPeriodsOnDay(DateTime.tuesday),
      unorderedEquals({(start: time1, end: time2)}),
    );
    // three times
    expect(test.getPeriodsOnDay(DateTime.monday), {
      (start: time1, end: time2),
      (start: time3, end: time4),
      (start: time2, end: time3),
    });
    // zero times
    expect(test.getPeriodsOnDay(DateTime.sunday), isEmpty);

    // getDurationOnDay
    // with three times (all added together)
    expect(
      test.getDurationOnDay(DateTime.monday),
      const Duration(hours: 1, minutes: 10 + 30 + 45),
    );
    // with only one time
    expect(
      test.getDurationOnDay(DateTime.wednesday),
      const Duration(minutes: 10),
    );
    // zero times
    expect(test.getDurationOnDay(DateTime.saturday), Duration.zero);

    // weeklyDuration
    expect(
      test.weeklyDuration,
      const Duration(hours: 1, minutes: 10 + 30 + 45 + 20),
    );

    // getDaysAtTime
    // time in the middle of a range
    // only one day
    expect(
      test.getDaysAtTime(HourMinute(hour: 4)),
      unorderedEquals({DateTime.monday}),
    );
    // edge time
    // three days
    expect(
      test.getDaysAtTime(time1),
      unorderedEquals(
        {DateTime.monday, DateTime.tuesday, DateTime.wednesday},
      ),
    );
    // zero days
    expect(test.getDaysAtTime(HourMinute(hour: 13)), isEmpty);

    // getPeriodOnDayAtTime
    // no period
    expect(
      test.getPeriodOnDayAtTime(time: time1, day: DateTime.thursday),
      isNull,
    );
    // time at start of period
    expect(
      test.getPeriodOnDayAtTime(time: time1, day: DateTime.tuesday),
      (start: time1, end: time2),
    );
    // time at end of period
    expect(
      test.getPeriodOnDayAtTime(time: time4, day: DateTime.monday),
      isNull,
    );
    // time in middle of period
    expect(
      test.getPeriodOnDayAtTime(
        time: time3.add(const Duration(minutes: 15)),
        day: DateTime.monday,
      ),
      (start: time3, end: time4),
    );

    // isAt
    // null
    expect(test.isAt(), isTrue);
    // day only
    expect(test.isAt(day: DateTime.monday), isTrue); // is at
    expect(test.isAt(day: DateTime.thursday), isFalse); // is not at
    // time only
    expect(test.isAt(time: HourMinute(hour: 4)), isTrue); // in range
    expect(test.isAt(time: time4), isFalse); // on trailing edge
    expect(test.isAt(time: time1), isTrue); // on leading edge -- multiple
    expect(test.isAt(time: HourMinute(hour: 22)), isFalse); // is not at
    // day and time
    expect(
      test.isAt(day: DateTime.wednesday, time: time1),
      isTrue,
    ); // both match
    // time doesn't match
    expect(
      test.isAt(day: DateTime.wednesday, time: HourMinute(hour: 22)),
      isFalse,
    );
    // day doesn't match
    expect(test.isAt(day: DateTime.thursday, time: time1), isFalse);
    // no match
    expect(
      test.isAt(day: DateTime.thursday, time: HourMinute(hour: 22)),
      isFalse,
    );
  });

  test('to string methods', () {
    final MeetingTime test = MeetingTime();
    final HourMinute time1 = HourMinute(hour: 1, minute: 50);
    final HourMinute time2 = HourMinute(hour: 2);
    final HourMinute time3 = HourMinute(hour: 21, minute: 30);
    final HourMinute time4 = HourMinute(hour: 23, minute: 15);

    // adding times
    test.add(day: DateTime.monday, start: time1, end: time2); // M 1:50 - 2:00
    test.add(day: DateTime.monday, start: time2, end: time3); // M 2:00 - 21:30
    test.add(day: DateTime.monday, start: time3, end: time4); // M 21:30 - 23:15
    test.add(day: DateTime.tuesday, start: time1, end: time2); // T 1:50 - 2:00
    test.add(day: DateTime.wednesday, start: time1, end: time2); // W 1:50-2:00

    // toString
    // like existing ClassOpen - 24hr
    expect(test.toString(), 'MTW 1:50 - 2:00\nM 2:00 - 21:30\nM 21:30 - 23:15');
    // like existing ClassOpen - 12hr
    expect(
      test.toString(is24hr: false),
      'MTW 1:50AM - 2:00AM\nM 2:00AM - 9:30PM\nM 9:30PM - 11:15PM',
    );

    // toStringExpanded
    // expanded out by day (all on new lines) - 24hr
    expect(
      test.toStringExpanded(),
      'M 1:50 - 2:00\nM 2:00 - 21:30\nM 21:30 - 23:15\nT 1:50 - 2:00\nW 1:50 - 2:00',
    );
    // expanded -- 12hr
    expect(
      test.toStringExpanded(is24hr: false),
      'M 1:50AM - 2:00AM\nM 2:00AM - 9:30PM\nM 9:30PM - 11:15PM\nT 1:50AM - 2:00AM\nW 1:50AM - 2:00AM',
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
    expect(test3, same(test4));
    expect(test3, test4);
    expect(test3.hashCode, test4.hashCode);
    // same content
    test4 = MeetingTime()
      ..add(day: DateTime.thursday, start: time1, end: time2);
    expect(identical(test3, test4), isFalse);
    expect(test3, test4);
    expect(test3.hashCode, test4.hashCode);
    // not equal
    expect(test2 == test3, isFalse);
    expect(test2.hashCode == test3.hashCode, isFalse);
    // changing to make equal
    test2.remove(day: DateTime.monday, start: time3, end: time4);
    test2.remove(day: DateTime.tuesday, start: time1, end: time2);
    expect(test2, test3);
    expect(test2.hashCode, test3.hashCode);
    // direct hashcode check
    final int checkHash = (DateTime.monday, time1, time2).hashCode +
        (DateTime.monday, time2, time3).hashCode +
        (DateTime.monday, time3, time4).hashCode +
        (DateTime.tuesday, time1, time2).hashCode +
        (DateTime.wednesday, time1, time2).hashCode;
    expect(test1.hashCode, checkHash);
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
    expect(testResults1.doesConflict, isFalse);
    expect(testResults1.conflicts, isEmpty);
    // no conflict -- same times, different days
    testResults1 = test1.checkConflict(test3);
    expect(testResults1.doesConflict, isFalse);
    expect(testResults1.conflicts, isEmpty);
    // no conflict -- same day, different times
    testResults1 = test1.checkConflict(test4);
    expect(testResults1.doesConflict, isFalse);
    expect(testResults1.conflicts, isEmpty);

    // checkConflict - conflicts
    // exact same
    testResults1 = test1.checkConflict(test1);
    expect(testResults1.doesConflict, isTrue);
    expect(
      testResults1.conflicts,
      unorderedEquals({(day: DateTime.monday, time: time3)}),
    );
    // offset times
    testResults1 = test3.checkConflict(test4);
    testResults2 = test4.checkConflict(test3);
    expect(testResults1.doesConflict && testResults2.doesConflict, isTrue);
    expect(testResults1.conflicts, unorderedEquals(testResults2.conflicts));
    expect(
      testResults1.conflicts,
      unorderedEquals({(day: DateTime.thursday, time: time2)}),
    );
    // several conflicts -- also different counts
    testResults1 = test6.checkConflict(test7);
    testResults2 = test7.checkConflict(test6);
    expect(testResults1.doesConflict && testResults2.doesConflict, isTrue);
    expect(testResults1.conflicts, unorderedEquals(testResults2.conflicts));
    expect(
      testResults1.conflicts,
      unorderedEquals({
        (day: DateTime.monday, time: time2),
        (day: DateTime.monday, time: time3),
        (day: DateTime.monday, time: time5),
        (day: DateTime.monday, time: time6),
      }),
    );
  });

  test('fromString constructor', () {
    // matching schedule.dart formatting:
    // single day, single time
    MeetingTime test;
    test = MeetingTime.fromString('T 05:00 - 06:50P');
    expect(test, hasLength(1));
    expect(
      test[0],
      (
        day: DateTime.tuesday,
        start: HourMinute(hour: 17),
        end: HourMinute(hour: 18, minute: 50)
      ),
    );

    // multiple days, single time
    test = MeetingTime.fromString('MTWF 01:00 - 01:50P');
    expect(test, hasLength(4));
    expect(
      test[0],
      (
        day: DateTime.monday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );
    expect(
      test[1],
      (
        day: DateTime.tuesday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );
    expect(
      test[2],
      (
        day: DateTime.wednesday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );
    expect(
      test[3],
      (
        day: DateTime.friday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );

    // multiple days, multiple times
    test = MeetingTime.fromString('MWF 01:00 - 01:50P/R 02:00 - 04:50P');
    expect(test, hasLength(4));
    expect(
      test[0],
      (
        day: DateTime.monday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );
    expect(
      test[1],
      (
        day: DateTime.wednesday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );
    expect(
      test[2],
      (
        day: DateTime.thursday,
        start: HourMinute(hour: 14),
        end: HourMinute(hour: 16, minute: 50)
      ),
    );
    expect(
      test[3],
      (
        day: DateTime.friday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 13, minute: 50)
      ),
    );

    // NOT matching schedule.dart formatting
    test = MeetingTime.fromString(
      'RU 02:10PM-04:25PM\nS 02:00 AM-04:50 AM\nS-13:00 - 14:15',
    );
    expect(test, hasLength(4));
    expect(
      test[0],
      (
        day: DateTime.thursday,
        start: HourMinute(hour: 14, minute: 10),
        end: HourMinute(hour: 16, minute: 25)
      ),
    );
    expect(
      test[1],
      (
        day: DateTime.saturday,
        start: HourMinute(hour: 2),
        end: HourMinute(hour: 4, minute: 50)
      ),
    );
    expect(
      test[2],
      (
        day: DateTime.saturday,
        start: HourMinute(hour: 13),
        end: HourMinute(hour: 14, minute: 15)
      ),
    );
    expect(
      test[3],
      (
        day: DateTime.sunday,
        start: HourMinute(hour: 14, minute: 10),
        end: HourMinute(hour: 16, minute: 25)
      ),
    );

    // same time listed
    test = MeetingTime.fromString('T 05:00 - 06:50P/T 05:00 - 06:50P');
    expect(test, hasLength(1));
    expect(
      test[0],
      (
        day: DateTime.tuesday,
        start: HourMinute(hour: 17),
        end: HourMinute(hour: 18, minute: 50)
      ),
      reason: 'handle same times in string',
    );

    // no time set
    test = MeetingTime.fromString('ARR');
    expect(test, isEmpty);

    // consistency
    test = MeetingTime(); // empty
    test.add(
      day: DateTime.tuesday,
      start: HourMinute(hour: 14),
      end: HourMinute(hour: 14, minute: 50),
    );
    test.add(
      day: DateTime.thursday,
      start: HourMinute(hour: 14),
      end: HourMinute(hour: 14, minute: 50),
    );
    test.add(
      day: DateTime.wednesday,
      start: HourMinute(hour: 13),
      end: HourMinute(hour: 15, minute: 50),
    );
    final MeetingTime test2 =
        MeetingTime.fromString(test.toString(is24hr: false));
    expect(test, test2);

    // proper error handling:
    // improper string - no space/- between days and time
    expect(
      () => MeetingTime.fromString('T05:00 - 06:50P'),
      throwsFormatException,
    );
    // improper string - bad day
    expect(
      () => MeetingTime.fromString('Q 05:00 - 06:50P'),
      throwsFormatException,
    );
    // improper string - bad time
    expect(
      () => MeetingTime.fromString('T 0X:00 - 06:50P'),
      throwsFormatException,
    );
    // improper string - bad spaces -- will go to delimination error from HourMinute because string happens to split into 3 by MeetingTime
    expect(
      () => MeetingTime.fromString('T09: 00 - 06:50P'),
      throwsFormatException,
    );
  });
}
