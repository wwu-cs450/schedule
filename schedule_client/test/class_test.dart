import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/campus.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/course.dart';
import 'package:schedule_client/domain/data_handler.dart';
import 'package:schedule_client/domain/department.dart';
import 'package:schedule_client/domain/instructor.dart';
import 'package:schedule_client/domain/meeting_time.dart';
import 'package:schedule_client/domain/subject.dart';
import 'package:schedule_client/domain/term.dart';

Set<Instructor> instructors = {Instructor('James Foster')};
void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });
  test('constructor and accessors', () {
    final course = Course(
      Department.departmentwithCode('CPTR'),
      Subject.subjectWithCode('CPTR'),
      'Software Engineering',
      '450',
      'upper',
      3,
      3,
    );
    final term = Term(2239, 'Fall 2023');
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
    assert(section.term.code == 2239);
    assert(section.term.name == 'Fall 2023');
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
      (element) => element.getClN() == '1829' && element.term.code == 2243,
    );
    expect(winterArt.isOpenForEnrollment, true);
    final Class fallArt = allClasses.firstWhere(
      (element) => element.getClN() == '1827' && element.term.code == 2239,
    );
    expect(fallArt.isOpenForEnrollment, false);
    final Class introArt = allClasses.firstWhere(
      (element) => element.getClN() == '1320' && element.term.code == 2239,
    );
    expect(introArt.fee, '\$0');
    final Class materialsArt = allClasses.firstWhere(
      (element) => element.getClN() == '1518' && element.term.code == 2239,
    );
    expect(materialsArt.fee, '\$81');
    final Class canceledArt = allClasses.firstWhere(
      (element) => element.getClN() == '1851' && element.term.code == 2241,
    );
    expect(canceledArt.specialNotes, 'Class Cancelled');
    final Class notCancelledArt = allClasses.firstWhere(
      (element) => element.getClN() == '1906' && element.term.code == 2241,
    );
    expect(notCancelledArt.specialNotes, '');
    final Class noConsent = allClasses.firstWhere(
      (element) => element.getClN() == '1851' && element.term.code == 2241,
    );
    expect(noConsent.consent, '');
    final Class consentRequired = allClasses.firstWhere(
      (element) => element.getClN() == '1156' && element.term.code == 2236,
    );
    expect(consentRequired.consent, 'Instructor Consent Required');
    final Class emptyWait = allClasses.firstWhere(
      (element) => element.getClN() == '1829' && element.term.code == 2243,
    );
    expect(emptyWait.waitlist == 0, true);
    final Class hasWait = allClasses.firstWhere(
      (element) => element.getClN() == '1104' && element.term.code == 2241,
    );
    expect(hasWait.waitlist > 0, true);
    final Class noVideo = allClasses.firstWhere(
      (element) => element.getClN() == '1829' && element.term.code == 2243,
    );
    expect(noVideo.video, 'NULL');
    final Class hasVideo = allClasses.firstWhere(
      (element) => element.getClN() == '1712' && element.term.code == 2243,
    );
    expect(hasVideo.video, 'Video');
  });
}
