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
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final allDepartments = Department.instances.first;
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    final all = Query(allDepartments, null, null).results().length;
    final dCount = Query(csDepartment, null, null).results().length;
    final sCount = Query(allDepartments, subject, null).results().length;
    final tCount = Query(allDepartments, null, term).results().length;
    final tAndsCount = Query(allDepartments, subject, term).results().length;
    final dAndtCount = Query(csDepartment, null, term).results().length;
    final bCount = Query(csDepartment, subject, term).results().length;
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
    final department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final list = Query(department, subject, null).results();
    assert(list.every((element) => element.course.department!.code == 'CPTR'));
    assert(list.every((element) => element.course.subject!.code == 'CPTR'));
  });
  test('query finds multiple codes within the Theology department', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final codes = Query(department, null, null).results();
    assert(codes.any((element) => element.course.subject!.code == 'RELB'));
    assert(codes.any((element) => element.course.subject!.code == 'RELH'));
    assert(codes.any((element) => element.course.subject!.code == 'RELM'));
    assert(codes.any((element) => element.course.subject!.code == 'RELP'));
    assert(codes.any((element) => element.course.subject!.code == 'RELT'));
    assert(codes.any((element) => element.course.subject!.code == 'SERV'));
  });

  test('query finds Winter 2024', () {
    final allDepartments = Department.instances.first;
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    final term = Term.instances.firstWhere((each) => each.code == 2241);
    final list = Query(allDepartments, null, term).results();
    assert(list.every((element) => element.course.term!.code == 2241));
  });
}
