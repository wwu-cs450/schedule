// Fix this test
// Currently, it only returns a set when subject and department are null
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';
import 'package:schedule/campus.dart';
import 'package:schedule/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('count query results', () {
    final csDepartment =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    expect(csDepartment.code, 'CPTR');
    final csSubject =
        Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final campus = Campus.instances.firstWhere((each) => each.code == 'CP');
    final allCampuses = Campus.instances.first;
    final allDepartments = Department.instances.first;
    final allSubjects = Subject.instances.first;
    final allTerms = Term.instances.first;
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
      list.every((element) => element.course.department!.code == 'CPTR'),
      isTrue,
    );
    expect(
      list.every((element) => element.course.subject!.code == 'CPTR'),
      isTrue,
    );
  });
  test('query finds multiple codes within the Theology department', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final codes = Query(department: department).results();
    expect(
      codes.any((element) => element.course.subject!.code == 'RELB'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject!.code == 'RELH'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject!.code == 'RELM'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject!.code == 'RELP'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject!.code == 'RELT'),
      isTrue,
    );
    expect(
      codes.any((element) => element.course.subject!.code == 'SERV'),
      isTrue,
    );
  });

  test('query finds Winter 2024', () {
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final list = Query(term: term).results();
    expect(list.every((element) => element.term.code == 2241), isTrue);
  });

  test('query finds College Place', () {
    final campus =
        Campus.instances.firstWhere((each) => each.name == 'College Place');
    final list = Query(campus: campus).results();
    expect(list.every((element) => element.campus.code == 'CP'), isTrue);
  });
}
