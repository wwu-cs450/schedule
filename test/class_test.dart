import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/course.dart';
import 'package:schedule/instructor.dart';

import 'package:schedule/class.dart';

Instructor instructor = Instructor('James Foster');
void main() {
  test('constructor and accessors', () {
    final course =
        Course('CPTR', 'CPTR', 'Software Engineering', 450, 'upper', 3);
    final section = Class(
      course,
      2239,
      20,
      'MWF 2:00PM-3:00PM',
      'KRH 210',
      instructor,
      'CP',
    );
    assert(section.course.title == 'Software Engineering');
    assert(section.term?.name == 'Fall 2023');
    assert(section.maxEnrollment == 20);
    assert(section.schedule == 'MWF 2:00PM-3:00PM');
    assert(section.classroom == 'KRH 210');
    assert(section.instructor == instructor);
    assert(section.campus?.name == 'College Place');
    assert(section.video == '');
    assert(section.consent == '');
    assert(section.specialNotes == '');
    assert(section.fee == 0);
    assert(section.currEnrollment == 0);
    assert(section.waitlist == 0);
    assert(section.section == 'A');
    assert(section.isOpenForEnrollment);

    section.changeEnrollmentStatus();
    assert(!section.isOpenForEnrollment);

    section.updateWaitlist('add');
    assert(section.waitlist == 1);
    section.updateWaitlist('drop');
    assert(section.waitlist == 0);
  });
}
