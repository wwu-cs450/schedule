// Fix this test
// Currently, it only returns a set when subject and department are null
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';
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
    final allDepartments = Department.instances.first;
    final allSubjects = Subject.instances.first;
    final allTerms = Term.instances.first;
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    expect(allSubjects.code, '');
    expect(allSubjects.name, 'ALL');
    expect(allTerms.code, 0);
    expect(allTerms.name, 'ALL');
    final all = Query(allDepartments, allSubjects, allTerms).results().length;
    final dCount = Query(csDepartment, allSubjects, allTerms).results().length;
    final sCount = Query(allDepartments, csSubject, allTerms).results().length;
    final tCount = Query(allDepartments, allSubjects, term).results().length;
    final tAndsCount = Query(allDepartments, csSubject, term).results().length;
    final dAndtCount = Query(csDepartment, allSubjects, term).results().length;
    final bCount = Query(csDepartment, csSubject, term).results().length;
    assert(
      all > dCount &&
          all > sCount &&
          all > bCount &&
          all > tCount &&
          all > tAndsCount &&
          all > dAndtCount,
    );
  });
  test('query finds CPTR', () {
    final allTerms = Term.instances.first;
    final department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final list = Query(department, subject, allTerms).results();
    assert(list.every((element) => element.course.department!.code == 'CPTR'));
    assert(list.every((element) => element.course.subject!.code == 'CPTR'));
  });
  test('query finds multiple codes within the Theology department', () {
    final allSubjects = Subject.instances.first;
    final allTerms = Term.instances.first;
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final codes = Query(department, allSubjects, allTerms).results();
    assert(codes.any((element) => element.course.subject!.code == 'RELB'));
    assert(codes.any((element) => element.course.subject!.code == 'RELH'));
    assert(codes.any((element) => element.course.subject!.code == 'RELM'));
    assert(codes.any((element) => element.course.subject!.code == 'RELP'));
    assert(codes.any((element) => element.course.subject!.code == 'RELT'));
    assert(codes.any((element) => element.course.subject!.code == 'SERV'));
  });

  test('query finds Winter 2024', () {
    final allSubjects = Subject.instances.first;
    final allDepartments = Department.instances.first;
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final list = Query(allDepartments, allSubjects, term).results();
    assert(list.every((element) => element.term.code == 2241));
  });
}
