// author:  Ethan Jansen
// date:    2023/10/26
// tests:   HourMinute
// Notes:
/*
   
*/

import 'package:client/domain/hourminute.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    // constructors/accessors
    // default
    final HourMinute time1 = HourMinute(); // 0:00
    expect(time1.hour, 0);
    expect(time1.minute, 0);
    // simple: hour and minute defined
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20
    expect(time2.hour, 6);
    expect(time2.minute, 20);
    // hour>23
    final HourMinute time3 = HourMinute(hour: 31, minute: 30); // 7:30
    expect(time3.hour, 7);
    expect(time3.minute, 30);
    // hour>23, minute>60 (extra minutes should add to hour)
    final HourMinute time4 = HourMinute(hour: 32, minute: 66); // 9:06
    expect(time4.hour, 9);
    expect(time4.minute, 6);
    // using DateTime
    final HourMinute time5 =
        HourMinute.fromDate(DateTime(2023, 5, 5, 13, 30, 50)); // 13:30
    expect(time5.hour, 13);
    expect(time5.minute, 30);
    // using fromString. 24hr
    final HourMinute time6 = HourMinute.fromString('09:30'); // 9:30
    expect(time6.hour, 9);
    expect(time6.minute, 30);
    // using fromString. AM
    final HourMinute time7 = HourMinute.fromString('9:30 am'); // 9:30
    expect(time7.hour, 9);
    expect(time7.minute, 30);
    // using fromString. PM
    final HourMinute time8 = HourMinute.fromString('09:30 pm'); // 21:30
    expect(time8.hour, 21);
    expect(time8.minute, 30);
    // using fromString. bad string -- should throw format exception
    expect(() => HourMinute.fromString('09-30'), throwsFormatException);
    // negative numbers -- should throw exception
    expect(
      () => HourMinute(hour: -1, minute: -99),
      throwsA(isA<NegativeTimeException>()),
    );
  });

  test('durations', () {
    final HourMinute time1 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20

    // get time after duration
    // no change
    HourMinute testTime = time2.add(const Duration(days: 1));
    expect(testTime, time2);
    // change without rolling over
    testTime = time2.add(const Duration(hours: 5, minutes: 30));
    expect(testTime.hour, 11);
    expect(testTime.minute, 50);
    // change with rolling over
    testTime = time2.add(const Duration(hours: 23, minutes: 110));
    expect(testTime.hour, 7);
    expect(testTime.minute, 10);

    // get duration between times
    // positive duration
    Duration testDur = time2.durationFrom(time1);
    expect(testDur, const Duration(hours: 5, minutes: 10));
    // negative duration
    testDur = time1.durationFrom(time2);
    expect(testDur, const Duration(hours: -5, minutes: -10));
  });

  test('toString', () {
    final HourMinute time1 = HourMinute(hour: 13, minute: 10); // 13:10
    final HourMinute time2 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time3 = HourMinute(hour: 1, minute: 1); // 1:01

    // 24hr - test 1
    expect(time1.toString(), '13:10');
    // 24hr - test 2
    expect(time1.toString(is24hr: true), '13:10');
    // 12hr - test 1
    expect(time1.toString(is24hr: false), '1:10PM');
    // 12hr - test 2
    expect(time2.toString(is24hr: false), '1:10AM');
    // correct padding
    expect(time3.toString(is24hr: false), '1:01AM');
  });

  test('comparisons', () {
    final HourMinute time1 = HourMinute(hour: 1, minute: 10); // 1:10
    final HourMinute time2 = HourMinute(hour: 6, minute: 20); // 6:20

    // compareTo
    expect(time1.compareTo(time2), isNegative);
    expect(time2.compareTo(time1), isPositive);
    expect(time1.compareTo(time1), isZero);

    // hashcode
    expect(time1.hashCode, 70.hashCode);

    // comparison operators
    expect(time1, lessThan(time2));
    expect(time1, lessThanOrEqualTo(time2));
    expect(time1, equals(time1));
    expect(time1, lessThanOrEqualTo(time1));
    expect(time2, greaterThan(time1));
    expect(time2, greaterThanOrEqualTo(time1));
    expect(time1, greaterThanOrEqualTo(time1));
  });

  test('More Strings', () {
    // PM time
    HourMinute time = HourMinute.fromString('2:00P');
    expect(time.hour, 14);
    expect(time.toString(), '14:00');
    expect(time.toString(is24hr: false), '2:00PM');
    // AM time
    time = HourMinute.fromString('2:00A');
    expect(time.hour, 2);
    expect(time.toString(), '2:00');
    expect(time.toString(is24hr: false), '2:00AM');
    // 12AM
    time = HourMinute.fromString('12:00A');
    expect(time.hour, 0);
    expect(time.toString(), '0:00');
    expect(time.toString(is24hr: false), '12:00AM');
    // 12PM
    time = HourMinute.fromString('12:00P');
    expect(time.hour, 12);
    expect(time.toString(), '12:00');
    expect(time.toString(is24hr: false), '12:00PM');
    // Weird time
    time = HourMinute.fromString('12:65P');
    expect(time.hour, 13);
    expect(time.toString(), '13:05');
    expect(time.toString(is24hr: false), '1:05PM');
    // Weird time -- wraps from AM to PM
    time = HourMinute.fromString('11:65A');
    expect(time.hour, 12);
    expect(time.toString(), '12:05');
    expect(time.toString(is24hr: false), '12:05PM');
  });
}
