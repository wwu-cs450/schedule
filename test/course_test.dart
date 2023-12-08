import 'package:flutter_test/flutter_test.dart';
import 'package:schedule/course.dart';
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';

void main() {
  test('constructor and accessors', () {
    final course = Course(
      Department.departmentwithCode('CPTR'),
      Subject.subjectWithCode('CPTR'),
      'Fundamentals of Programming I',
      '141',
      'lower',
      4,
      4,
    );
    assert(course.department.code == 'CPTR');
    assert(course.subject.code == 'CPTR');
    assert(course.title == 'Fundamentals of Programming I');
    assert(course.number == '141');
    assert(course.level == 'lower');
    assert(course.creditsMin == 4);
    assert(!course.isGeneralStudies);
  });
  test('constructor and accessors on lab', () {
    final course = Course(
      Department.departmentwithCode('ART'),
      Subject.subjectWithCode('DRMA'),
      'Performance',
      '253SN',
      'upper',
      0,
      0,
    );
    assert(course.number == '253SN');
  });
  test('course credit numbers from HTML', () {
    final courses = Course.instances;
    assert(
      courses.any(
        (element) => element.creditsMin == 4.5,
      ),
    );
    assert(
      courses.any(
        (element) => element.creditsMin == element.creditsMax,
      ),
    );
  });
  test('course titles from HTML', () {
    final courses = Course.instances;
    assert(
      courses.any(
        (element) => element.title == 'Introduction to Printmaking',
      ),
    );
  });
}
