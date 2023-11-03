// Fix this test
// Currently, it only returns a set when subject and department are null
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('count query results', () {
    final csDepartment =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    expect(csDepartment.code, 'CPTR');
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final allDepartments = Department.instances.first;
    expect(allDepartments.code, '');
    expect(allDepartments.name, 'ALL');
    final all = Query(allDepartments, null).results().length;
    final dCount = Query(csDepartment, null).results().length;
    final sCount = Query(allDepartments, subject).results().length;
    final bCount = Query(csDepartment, subject).results().length;
    assert(all > dCount);
    assert(all > sCount);
    assert(all > bCount);
  });
  test('query finds CPTR', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    final subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    final list = Query(department, subject).results();
    assert(list.every((element) => element.course.department!.code == 'CPTR'));
    assert(list.every((element) => element.course.subject!.code == 'CPTR'));
  });
  test('query finds multiple codes within the Theology department', () {
    final department =
        Department.instances.firstWhere((each) => each.code == 'RELB');
    final codes = Query(department, null).results();
    assert(codes.any((element) => element.course.subject!.code == 'RELB'));
    assert(codes.any((element) => element.course.subject!.code == 'RELH'));
    assert(codes.any((element) => element.course.subject!.code == 'RELM'));
    assert(codes.any((element) => element.course.subject!.code == 'RELP'));
    assert(codes.any((element) => element.course.subject!.code == 'RELT'));
    assert(codes.any((element) => element.course.subject!.code == 'SERV'));
  });
}
