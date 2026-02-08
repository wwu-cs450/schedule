import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/course.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/instructor.dart';
import 'package:client/domain/meeting_time.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:flutter_test/flutter_test.dart';

Set<Instructor> instructors = {Instructor('James Foster')};
void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  test('constructor and accessors', () {
    final course = Course(
      Department.departmentWithCode('CPTR'),
      Subject.fromCode('CPTR'),
      'Software Engineering',
      '450',
      'upper',
      3,
      3,
    );
    final term = Term(2249, 'Fall 2024');
    final campus = Campus('CP', 'College Place');
    final section = Class(
      course,
      term,
      20,
      MeetingTime.fromString('MWF 2:00PM-3:00PM'),
      'KRH 210',
      instructors,
      campus,
      9999,
    );
    assert(section.course.title == 'Software Engineering');
    assert(section.term.code == 2249);
    assert(section.term.name == 'Fall 2024');
    assert(section.maxEnrollment == 20);
    assert(section.schedule.toString(is24hr: false) == 'MWF 2:00PM - 3:00PM');
    assert(section.classroom == 'KRH 210');
    assert(section.instructors == instructors);
    assert(section.campus.code == 'CP');
    assert(section.campus.name == 'College Place');
    assert(section.video == '');
    assert(section.consent == '');
    assert(section.specialNotes == '');
    assert(section.fee == '0');
    assert(section.currEnrollment == 0);
    assert(section.waitlist == 0);
    assert(section.classNumber == 9999);
    assert(section.section == 'A');
    assert(section.isOpenForEnrollment);

    section.changeEnrollmentStatus();
    assert(!section.isOpenForEnrollment);

    section.updateWaitlist('add');
    assert(section.waitlist == 1);
    section.updateWaitlist('drop');
    assert(section.waitlist == 0);
  });

  test('test instances', () {
    final allClasses = Class.instances;
    expect(allClasses.isNotEmpty, true);
    final Class winterArt = allClasses.firstWhere(
      (element) => element.getClN() == '1829' && element.term.code == 2253,
    );
    expect(winterArt.isOpenForEnrollment, true);
    final Class fallArt = allClasses.firstWhere(
      (element) => element.getClN() == '1827' && element.term.code == 2249,
    );
    expect(fallArt.isOpenForEnrollment, false);
    final Class introArt = allClasses.firstWhere(
      (element) => element.getClN() == '1320' && element.term.code == 2249,
    );
    expect(introArt.fee, '\$0');
    final Class materialsArt = allClasses.firstWhere(
      (element) => element.getClN() == '1518' && element.term.code == 2249,
    );
    expect(materialsArt.fee, '\$81');
    final Class canceledArt = allClasses.firstWhere(
      (element) => element.getClN() == '1851' && element.term.code == 2251,
    );
    expect(canceledArt.specialNotes, 'Class Cancelled');
    final Class notCancelledArt = allClasses.firstWhere(
      (element) => element.getClN() == '1906' && element.term.code == 2251,
    );
    expect(notCancelledArt.specialNotes, '');
    final Class noConsent = allClasses.firstWhere(
      (element) => element.getClN() == '1851' && element.term.code == 2251,
    );
    expect(noConsent.consent, '');
    final Class consentRequired = allClasses.firstWhere(
      (element) => element.getClN() == '1156' && element.term.code == 2246,
    );
    expect(consentRequired.consent, 'Instructor Consent Required');
    final Class emptyWait = allClasses.firstWhere(
      (element) => element.getClN() == '1829' && element.term.code == 2253,
    );
    expect(emptyWait.waitlist == 0, true);
    final Class hasWait = allClasses.firstWhere(
      (element) => element.getClN() == '1104' && element.term.code == 2251,
    );
    expect(hasWait.waitlist > 0, true);
    final Class noVideo = allClasses.firstWhere(
      (element) => element.getClN() == '1829' && element.term.code == 2253,
    );
    expect(noVideo.video, 'NULL');
    final Class hasVideo = allClasses.firstWhere(
      (element) => element.getClN() == '1712' && element.term.code == 2253,
    );
    expect(hasVideo.video, 'Video');
    final Class noStudents = allClasses.firstWhere(
      (element) => element.getClN() == '1881' && element.term.code == 2253,
    );
    expect(noStudents.currEnrollment, 0);
    final Class hasStudents = allClasses.firstWhere(
      (element) => element.getClN() == '1523' && element.term.code == 2249,
    );
    expect(hasStudents.currEnrollment, 62);
  });

  test('getAvailableClassrooms', () {
    final MeetingTime schedule = MeetingTime.fromString('MWF 2:00PM-3:00PM');
    final List<String> availableClassrooms = Class.getAvailableClassrooms(
      schedule,
    );
    expect(availableClassrooms.isNotEmpty, true);
    expect(availableClassrooms.contains('KRH 210'), false);
  });
}
