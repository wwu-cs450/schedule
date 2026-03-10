import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/course.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/instructor.dart';
import 'package:client/domain/meeting_time.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Class.getAllClassrooms', () {
    setUpAll(() async {
      // Clear _instances before each test to ensure isolation
      Class.instances.clear();
    });

    test('returns unique classrooms from _instances', () {
      //Add sample classes for testing

      //test 1
      final course1 = Course(
        Department.departmentWithCode('CPTR'),
        Subject.fromCode('CPTR'),
        'Software Engineering',
        '450',
        'upper',
        3,
        3,
      );
      final term1 = Term(2249, 'Fall 2024');
      final campus1 = Campus('CP', 'College Place');
      final section1 = Class(
        course1,
        term1,
        20,
        MeetingTime.fromString('MWF 2:00PM-3:00PM'),
        'KRH 210',
        {Instructor('James Foster')},
        campus1,
        9999,
      );

      //test 2 - this is a duplicate class to test if the function returns unique classrooms
      final course2 = Course(
        Department.departmentWithCode('CPTR'),
        Subject.fromCode('CPTR'),
        'Software Engineering',
        '452',
        'upper',
        3,
        3,
      );
      final term2 = Term(2249, 'Fall 2024');
      final campus2 = Campus('CP', 'College Place');
      final section2 = Class(
        course2,
        term2,
        20,
        MeetingTime.fromString('MWF 2:00PM-3:00PM'),
        'KRH 210',
        {Instructor('James Foster')},
        campus2,
        9999,
      );

      //Add the instances to the Class.instances
      Class.instances.addAll({section1, section2});

      //fetch the classrooms
      final classrooms = Class.getAllClassrooms();

      // Assert
      expect(classrooms, contains('KRH 210'));
      expect(classrooms.length, 1);
    });
  });
}
