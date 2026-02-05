import 'package:client/domain/course.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/subject.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });
  test('constructor and accessors', () {
    final course = Course(
      Department.departmentWithCode('CPTR'),
      Subject.fromCode('CPTR'),
      'Fundamentals of Programming I',
      '141',
      'lower',
      4,
      4,
    );
    expect(course.department.code, 'CPTR');
    expect(course.subject.code, 'CPTR');
    expect(course.title, 'Fundamentals of Programming I');
    expect(course.number, '141');
    expect(course.level, 'lower');
    expect(course.creditsMin, 4);
    expect(course.isGeneralStudies, false);
    expect(course.title, 'Fundamentals of Programming I');
    expect(course.number, '141');
    expect(course.level, 'lower');
    expect(course.creditsMin, 4);
    expect(course.isGeneralStudies, false);
  });
  test('constructor and accessors on lab', () {
    final course = Course(
      Department.departmentWithCode('ART'),
      Subject.fromCode('DRMA'),
      'Performance',
      '253SN',
      'upper',
      0,
      0,
    );
    expect(course.number, '253SN');
  });
  test('course credit numbers from CSV', () {
    final courses = Course.instances;
    expect(courses.any((element) => element.creditsMin == 4.5), true);
    expect(
      courses.any(
        (element) =>
            element.creditsMin == 1 &&
            element.creditsMax == 4, // Test for NRSG494 Internship
      ),
      true,
    );
    expect(
      courses.any((element) => element.creditsMin != element.creditsMax),
      true,
    );
    expect(
      courses.any((element) => element.creditsMin == element.creditsMax),
      true,
    );
  });
  test('course titles from HTML', () {
    final courses = Course.instances;
    expect(
      courses.any((element) => element.title == 'Introduction to Printmaking'),
      true,
    );
  });
}
