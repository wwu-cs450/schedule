import 'package:flutter_test/flutter_test.dart';
import 'package:schedule/course.dart';

void main() {
  test('constructor and accessors', () {
    final course = Course(
      'CPTR',
      'CPTR',
      'Fundamentals of Programming I',
      '141',
      'lower',
      4,
    );
    assert(course.department?.name == 'Computer Science');
    assert(course.subject?.name == 'Computer Science');
    assert(course.title == 'Fundamentals of Programming I');
    assert(course.number == '141');
    assert(course.level == 'lower');
    assert(course.credits == 4);
    assert(!course.isGeneralStudies);
  });
  test('constructor and accessors on lab', () {
    final course = Course(
      'ART',
      'DRMA',
      'Performance',
      '253SN',
      'upper',
      0,
    );
    assert(course.number == '253SN');
  });
}
