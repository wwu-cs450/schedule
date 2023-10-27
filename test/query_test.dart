// Fix this test
// Currently, it only returns a set when subject and department are null
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('count query results', () {
    var department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    var subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    var all = Query(null, null).results().length;
    var dCount = Query(department, null).results().length;
    var sCount = Query(null, subject).results().length;
    var bCount = Query(department, subject).results().length;
    assert(all > dCount && all > sCount && all > bCount);
  });
  test('query finds CPTR', () {
    var department =
        Department.instances.firstWhere((each) => each.code == 'CPTR');
    var subject = Subject.instances.firstWhere((each) => each.code == 'CPTR');
    var list = Query(department, subject).results();
    assert(list.every((element) => element.course.department!.code == 'CPTR'));
    assert(list.every((element) => element.course.subject!.code == 'CPTR'));
  });
}
