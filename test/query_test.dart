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
    final all = Query(allDepartments, allSubjects, allTerms, allCampuses)
        .results()
        .length;
    final dCount = Query(csDepartment, allSubjects, allTerms, allCampuses)
        .results()
        .length;
    final sCount = Query(allDepartments, csSubject, allTerms, allCampuses)
        .results()
        .length;
    final tCount =
        Query(allDepartments, allSubjects, term, allCampuses).results().length;
    final cCount =
        Query(allDepartments, allSubjects, allTerms, campus).results().length;
    final tAndsCount =
        Query(allDepartments, csSubject, term, allCampuses).results().length;
    final dAndtCount =
        Query(csDepartment, allSubjects, term, allCampuses).results().length;
    final bCount =
        Query(csDepartment, csSubject, term, campus).results().length;
    assert(
      all > dCount &&
          all > sCount &&
          all > tCount &&
          all > cCount &&
          all > tAndsCount &&
          all > dAndtCount &&
          all > bCount,
    );
  });
  test('query finds CPTR', () {
    final allTerms = Term.instances.first;
    final department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    final allCampuses = Campus.instances.first;
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final list = Query(department, subject, allTerms, allCampuses).results();
    assert(list.every((element) => element.course.department!.code == 'CPTR'));
    assert(list.every((element) => element.course.subject!.code == 'CPTR'));
  });
  test('query finds multiple codes within the Theology department', () {
    final allSubjects = Subject.instances.first;
    final allTerms = Term.instances.first;
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final allCampuses = Campus.instances.first;
    final codes =
        Query(department, allSubjects, allTerms, allCampuses).results();
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
    final allCampuses = Campus.instances.first;
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final list =
        Query(allDepartments, allSubjects, term, allCampuses).results();
    assert(list.every((element) => element.term.code == 2241));
  });

  test('query finds College Place', () {
    final allSubjects = Subject.instances.first;
    final allDepartments = Department.instances.first;
    final allTerms = Term.instances.first;
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    final campus =
        Campus.instances.firstWhere((each) => each.name == 'College Place');
    final list = Query(allDepartments, allSubjects, allTerms, campus).results();
    assert(list.every((element) => element.campus.code == 'CP'));
  });
}
