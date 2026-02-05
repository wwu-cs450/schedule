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
    expect(section.course.title, 'Software Engineering');
    expect(section.term.code, 2249);
    expect(section.term.name, 'Fall 2024');
    expect(section.maxEnrollment, 20);
    expect(section.schedule.toString(is24hr: false), 'MWF 2:00PM - 3:00PM');
    expect(section.classroom, 'KRH 210');
    expect(section.instructors, instructors);
    expect(section.campus.code, 'CP');
    expect(section.campus.name, 'College Place');
    expect(section.video, '');
    expect(section.consent, '');
    expect(section.specialNotes, '');
    expect(section.fee, '0');
    expect(section.currEnrollment, 0);
    expect(section.waitlist, 0);
    expect(section.classNumber, 9999);
    expect(section.section, 'A');
    expect(section.isOpenForEnrollment, true);

    section.changeEnrollmentStatus();
    expect(section.isOpenForEnrollment, false);

    section.updateWaitlist('add');
    expect(section.waitlist, 1);
    section.updateWaitlist('drop');
    expect(section.waitlist, 0);
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

  group('includesDays schedule filtering', () {
    final course = Course(
      Department.departmentWithCode('CPTR'),
      Subject.fromCode('CPTR'),
      'Test Course',
      '101',
      'lower',
      3,
      3,
    );
    final term = Term(2249, 'Fall 2024');
    final campus = Campus('CP', 'College Place');

    final mwfClass = Class(
      course,
      term,
      20,
      MeetingTime.fromString('MWF 10:00AM-11:00AM'),
      'TEST 101',
      instructors,
      campus,
      1001,
    );

    final mtwrClass = Class(
      course,
      term,
      20,
      MeetingTime.fromString('MTWR 2:00PM-3:00PM'),
      'TEST 102',
      instructors,
      campus,
      1002,
    );

    final mondayOnlyClass = Class(
      course,
      term,
      20,
      MeetingTime.fromString('M 1:00PM-2:00PM'),
      'TEST 103',
      instructors,
      campus,
      1003,
    );

    final arrClass = Class(
      course,
      term,
      20,
      MeetingTime.fromString('ARR'),
      'TEST 104',
      instructors,
      campus,
      1004,
    );

    test('Any logic - empty list shows all', () {
      expect(mwfClass.includesDays([], logic: 'Any'), true);
      expect(arrClass.includesDays([], logic: 'Any'), true);
    });

    test('Any logic - all days selected shows all', () {
      final allDays = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
      ];
      expect(mwfClass.includesDays(allDays, logic: 'Any'), true);
      expect(arrClass.includesDays(allDays, logic: 'Any'), true);
    });

    test(
      'Any logic - shows class if it meets on at least one selected day',
      () {
        expect(mwfClass.includesDays(['Monday'], logic: 'Any'), true);
        expect(mwfClass.includesDays(['Tuesday'], logic: 'Any'), false);
        expect(
          mwfClass.includesDays(['Monday', 'Tuesday'], logic: 'Any'),
          true,
        );
        expect(
          mwfClass.includesDays(['Tuesday', 'Thursday'], logic: 'Any'),
          false,
        );
      },
    );

    test('All logic - shows class only if it meets on all selected days', () {
      expect(mtwrClass.includesDays(['Monday', 'Tuesday'], logic: 'All'), true);
      expect(mtwrClass.includesDays(['Monday', 'Friday'], logic: 'All'), false);
      expect(mondayOnlyClass.includesDays(['Monday'], logic: 'All'), true);
      expect(
        mondayOnlyClass.includesDays(['Monday', 'Tuesday'], logic: 'All'),
        false,
      );
    });

    test('All logic - can have additional days beyond selected', () {
      // MWF class meets on Monday, Wednesday, Friday
      // If we select just Monday and Wednesday, it should still match
      expect(
        mwfClass.includesDays(['Monday', 'Wednesday'], logic: 'All'),
        true,
      );
      // But if we select days it doesn't meet on, it shouldn't match
      expect(mwfClass.includesDays(['Monday', 'Tuesday'], logic: 'All'), false);
    });

    test('Exclude logic - hides class if it meets on any selected day', () {
      expect(mwfClass.includesDays(['Monday'], logic: 'Exclude'), false);
      expect(mwfClass.includesDays(['Tuesday'], logic: 'Exclude'), true);
      expect(
        mwfClass.includesDays(['Tuesday', 'Thursday'], logic: 'Exclude'),
        true,
      );
      expect(
        mwfClass.includesDays(['Monday', 'Tuesday'], logic: 'Exclude'),
        false,
      );
    });

    test('Exclude logic - shows ARR classes regardless of days', () {
      expect(arrClass.includesDays(['Monday'], logic: 'Exclude'), true);
      expect(
        arrClass.includesDays([
          'Monday',
          'Tuesday',
          'Wednesday',
        ], logic: 'Exclude'),
        true,
      );
    });

    test('Exclude logic - all days selected hides all regular classes', () {
      final allDays = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
      ];
      expect(mwfClass.includesDays(allDays, logic: 'Exclude'), false);
      expect(mtwrClass.includesDays(allDays, logic: 'Exclude'), false);
      expect(arrClass.includesDays(allDays, logic: 'Exclude'), true);
    });
  });
}
