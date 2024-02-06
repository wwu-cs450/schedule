// Fix this test
// Currently, it only returns a set when subject and department are null

import 'package:gui/department.dart';
import 'package:gui/data_handler.dart';
import 'package:gui/subject.dart';
import 'package:gui/term.dart';
import 'package:gui/campus.dart';
import 'package:gui/query.dart';
import 'package:gui/hourminute.dart';
import 'package:gui/class.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });
  test('null query (all results)', () {
    expect(Query().results().length, 2371);
  });

  test('count query results', () {
    final csDepartment =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    expect(csDepartment.code, 'CPTR');
    final csSubject =
        Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final campus = Campus.instances.firstWhere((each) => each.code == 'CP');
    final allCampuses = Campus.allCampuses();
    final allDepartments = Department.allDepartments();
    final allSubjects = Subject.allSubjects();
    final allTerms = Term.allTerms();
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    expect(allSubjects.code, '');
    expect(allSubjects.name, 'ALL');
    expect(allTerms.code, 0);
    expect(allTerms.name, 'ALL');
    expect(allCampuses.code, '');
    expect(allCampuses.name, 'ALL');
    final all = Query().results().length;
    final dCount = Query(department: csDepartment).results().length;
    final sCount = Query(subject: csSubject).results().length;
    final tCount = Query(term: term).results().length;
    final cCount = Query(campus: campus).results().length;
    final tAndsCount = Query(subject: csSubject, term: term).results().length;
    final dAndtCount =
        Query(department: csDepartment, term: term).results().length;
    final bCount =
        Query(department: csDepartment, subject: csSubject, term: term)
            .results()
            .length;
    expect(
      all > dCount &&
          all > sCount &&
          all > tCount &&
          all > cCount &&
          all > tAndsCount &&
          all > dAndtCount &&
          all > bCount,
      isTrue,
    );
  });
  test('query finds CPTR', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final list = Query(department: department, subject: subject).results();
    expect(
      list.every((element) => element.course.department.code == 'CPTR'),
      isTrue,
    );
    expect(
      list.every((element) => element.course.subject.code == 'CPTR'),
      isTrue,
    );
  });
  test('query finds multiple codes within the Theology department', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final codes = Query(department: department).results();
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

  test('query finds Summer 2023', () {
    final term = Term.instances.firstWhere((each) => each.code == 2236);
    final list = Query(term: term).results();
    expect(list.every((element) => element.term.code == 2236), isTrue);
  });
  test('query finds class number 1408', () {
    final list = Query(classNumber: 1408).results();
    expect(list.every((element) => element.classNumber == 1408), isTrue);
    expect(list.length == 2, isTrue);
  });

  test('query finds College Place', () {
    final campus =
        Campus.instances.firstWhere((each) => each.name == 'College Place');
    final list = Query(campus: campus).results();
    expect(list.every((element) => element.campus.code == 'CP'), isTrue);
  });

  test('Query times', () {
    final int allLength = Query().results().length;
    final Set<Class> noSpecial = Query(includeSpecialTimes: false).results();
    final Set<Class> largeRange =
        Query(times: (start: HourMinute(hour: 8), end: HourMinute(hour: 14)))
            .results();
    final Set<Class> largeRangeSpecificDay = Query(
      days: {DateTime.tuesday},
      times: (start: HourMinute(hour: 8), end: HourMinute(hour: 14)),
    ).results();
    final int shortRangeLength =
        Query(times: (start: HourMinute(hour: 8), end: HourMinute(hour: 10)))
            .results()
            .length;
    // I think it is actually sunday but classopen doesn't follow the same day letter standard
    final Set<Class> containsSkiing = Query(
      days: {
        DateTime.saturday,
      },
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
      containsSkiing
          .where((e) => e.course.title == 'Downhill Skiing/Snowboarding'),
      isNotEmpty,
    );
  });
}
