// Fix this test
// Currently, it only returns a set when subject and department are null

import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/persister.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final searchCriteria = Filters();

  setUp(() async {
    Term.defaultTermIndex = 1; // 2024-2025
    AbstractPersister.instance = MockPersister();
    await searchCriteria.reset();
    await DataHandler.fetchData(test: true);
  });

  test('null query (all results)', () {
    expect(Query().results().length, 2370);
  });

  test('count query results', () async {
    final all = Query().results().length;

    final csDepartment = Department.instances.firstWhere(
      (each) => each.code == 'CPTR',
    );
    await searchCriteria.setDepartments([csDepartment]);
    final dCount = Query().results().length;
    expect(dCount < all, isTrue);

    final csSubject = Subject.instances.firstWhere(
      (each) => each.code == 'CPTR',
    );
    await searchCriteria.reset();
    await searchCriteria.setSubjects([csSubject]);
    final sCount = Query().results().length;
    expect(sCount < all, isTrue);

    final term = Term.instances.firstWhere((each) => each.code == 2241);
    await searchCriteria.reset();
    await searchCriteria.setTerm(term);
    final tCount = Query().results().length;
    expect(tCount < all, isTrue);

    final campus = Campus.instances.firstWhere((each) => each.code == 'CP');
    await searchCriteria.reset();
    await searchCriteria.setCampuses([campus]);
    final cCount = Query().results().length;
    expect(cCount, lessThan(all));
  });

  test('query finds CPTR', () async {
    final department = Department.instances.firstWhere(
      (each) => each.code == 'CPTR',
    );
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    await searchCriteria.setDepartments([department]);
    await searchCriteria.setSubjects([subject]);
    final list = Query().results();
    expect(
      list.every((element) => element.course.department.code == 'CPTR'),
      isTrue,
    );
    expect(
      list.every((element) => element.course.subject.code == 'CPTR'),
      isTrue,
    );
  });

  test('query finds multiple codes within the Theology department', () async {
    final department = Department.instances.firstWhere(
      (each) => each.code == 'RELB',
    );
    await searchCriteria.setDepartments([department]);
    final codes = Query().results();
    expect(
      codes.any((element) => element.course.subject.code == 'RELB'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject.code == 'RELH'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject.code == 'RELM'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject.code == 'RELP'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject.code == 'RELT'),
      isTrue,
    );
    // With the current implementation HTMLHandler classifies 'SERV' as 'NDEP' (it is both 'NDEP' and 'RELB')
    // this is consistent with csv test data
    expect(
      codes.any((element) => element.course.subject.code == 'SERV'),
      isFalse,
    );
  });

  test('query finds Summer 2023', () async {
    final term = Term.instances.firstWhere((each) => each.code == 2236);
    await searchCriteria.setTerm(term);
    final list = Query().results();
    expect(list.every((element) => element.term.code == 2236), isTrue);
  });

  test('query finds class number 1408', () async {
    await searchCriteria.setClassNumber(1408);
    final list = Query().results();
    expect(list.every((element) => element.classNumber == 1408), isTrue);
    expect(list.length == 2, isTrue);
  });

  test('query finds College Place', () async {
    final campus = Campus.instances.firstWhere(
      (each) => each.name == 'College Place',
    );
    await searchCriteria.setCampuses([campus]);
    final list = Query().results();
    expect(list.every((element) => element.campus.code == 'CP'), isTrue);
  });

  test('Query times', () {
    final int allLength = Query().results().length;
    final Set<Class> noSpecial = Query(includeSpecialTimes: false).results();
    final Set<Class> largeRange = Query(
      times: (start: HourMinute(hour: 8), end: HourMinute(hour: 14)),
    ).results();
    final Set<Class> largeRangeSpecificDay = Query(
      days: {DateTime.tuesday},
      times: (start: HourMinute(hour: 8), end: HourMinute(hour: 14)),
    ).results();
    final int shortRangeLength = Query(
      times: (start: HourMinute(hour: 8), end: HourMinute(hour: 10)),
    ).results().length;
    // I think it is actually sunday but classopen doesn't follow the same day letter standard
    final Set<Class> containsSkiing = Query(
      days: {DateTime.saturday},
    ).results();

    // check lenghts
    expect(
      allLength > noSpecial.length &&
          allLength > largeRange.length &&
          largeRange.length > largeRangeSpecificDay.length &&
          largeRange.length > shortRangeLength,
      isTrue,
    );

    // no special (may still include ARR if part of larger time)
    expect(
      noSpecial.every(
        (e) => !(e.schedule.toString() == 'ARR') && e.schedule.isNotEmpty,
      ),
      isTrue,
    );
    expect(
      largeRange.every(
        (e) => !(e.schedule.toString() == 'ARR') && e.schedule.isNotEmpty,
      ),
      isTrue,
    );
    // includes tuesday (T)
    expect(
      largeRangeSpecificDay.every((e) => e.schedule.toString().contains('T')),
      isTrue,
    );
    // only skiing
    expect(
      containsSkiing.where(
        (e) => e.course.title == 'Downhill Skiing/Snowboarding',
      ),
      isNotEmpty,
    );
  });
}
