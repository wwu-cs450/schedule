import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/course.dart';
import 'package:schedule_client/domain/data_handler.dart';
import 'package:schedule_client/domain/department.dart';
import 'package:schedule_client/domain/subject.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(true);
  });
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
  test('course credit numbers from CSV', () {
    final courses = Course.instances;
    assert(
      courses.any(
        (element) => element.creditsMin == 4.5,
      ),
    );
    assert(
      courses.any(
        (element) =>
            element.creditsMin == 1 &&
            element.creditsMax == 4, // Test for NRSG494 Internship
      ),
    );
  });
}
