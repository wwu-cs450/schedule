import 'dart:math';

import 'package:schedule_client/domain/campus.dart';
import 'package:schedule_client/domain/course.dart';
import 'package:schedule_client/domain/data_handler.dart';
import 'package:schedule_client/domain/hourminute.dart';
import 'package:schedule_client/domain/instructor.dart';
import 'package:schedule_client/domain/meeting_time.dart';
import 'package:schedule_client/domain/term.dart';

class Class implements Comparable {
  Class(
    this.course,
    this.term,
    this.maxEnrollment,
    this.schedule,
    this.classroom,
    this.instructors,
    this.campus,
    this.classNumber, [
    this.section = 'A',
    this.video = '',
    this.consent = '',
    this.specialNotes = '',
    this.fee = '0',
    this.currEnrollment = 0,
    this.waitlist = 0,
    this.isOpenForEnrollment = true,
    this.saved = false,
  ]);

  Course course;
  Term term;
  String section;
  int maxEnrollment;
  int currEnrollment;
  bool isOpenForEnrollment;
  int waitlist;
  String fee;
  MeetingTime schedule;
  String classroom;
  Set<Instructor> instructors;
  Campus campus;
  String video;
  String consent;
  int classNumber;
  String specialNotes;
  bool saved;

  static final _instances = <Class>{};

  static Set<Class> get instances {
    if (_instances.isEmpty) {
      Class._initialize();
    }
    return _instances;
  }

  /*
  0  CRSE_OFFER_NBR
  1  CAMPUS
  2  ACAD_YEAR
  3  ACAD_ORG
  4  WWU_ACAD_ORG_DESCR
  5  CLASS_NBR
  6  WWU_GS
  7  SUBJECT
  8  WWU_SUM1
  9  WWU_AUT
  10  WWU_WTR
  11  WWU_SPR
  12  WWU_SUM2
  13  CLASS_SECTION
  14  DESCR
  15  WWU_UNITS
  16  ENRL_STAT
  17  ENRL_TOT
  18  ENRL_CAP
  19  WAIT_TOT
  20  FEE_AMT
  21  WWU_MTG_PAT_COMB
  22  WWU_ROOM
  23  WWU_INSTR_NAME
  24  DESCRLONG
  25  INSTRUCTION_MODE
  26  SCHEDULE_PRINT
  27  VIDEO_LINK
  28  CONSENT
  29  CONSENT_DESCR
  */
  static void _initialize() {
    Course.getAllCourses();
    final classData = DataHandler.data;
    for (final listing in classData) {
      final courseNumber = '${listing[8].trim()}'
          '${listing[9].trim()}'
          '${listing[10].trim()}'
          '${listing[11].trim()}'
          '${listing[12].trim()}';
      final currCourse = Course.instances.firstWhere(
        (each) =>
            each.subject.code == listing[7] && each.number == courseNumber,
      );
      final Set<Instructor> currInstructors = Instructor.instances
          .where((each) => listing[23].contains(each.name))
          .toSet();
      late final Campus currCampus;
      try {
        currCampus =
            Campus.instances.firstWhere((each) => each.code == listing[1]);
      } catch (e) {
        // print('Campus not found: "${listing[1]}"');
        rethrow;
      }
      var termYear = (int.parse(listing[2]) / 1000).truncate().toString() +
          (int.parse(listing[2]) % 2000).toString();
      var termMonth = '';
      var termFound = '';
      final bool isOpen = listing[16] == 'Open';
      for (int i = 8; i <= 12; i++) {
        termFound = listing[i].toString();
        if (termFound != '') {
          if (i <= 9) {
            termYear = (int.parse(termYear) - 1).toString();
          }
          if (i == 9) {
            termMonth = '9';
          } else if (i == 10) {
            termMonth = '1';
          } else if (i == 11) {
            termMonth = '3';
          } else {
            termMonth = '6';
          }
          break;
        }
      }
      final String section = listing[13];
      final String currFee;
      if (listing[20].isNotEmpty) {
        currFee = listing[20];
      } else {
        currFee = '0';
      }
      final String currNotes;
      if (listing[24].isNotEmpty) {
        currNotes = listing[24];
      } else {
        currNotes = '';
      }
      final String currConsent;
      if (listing[29].isNotEmpty) {
        currConsent = listing[29].trim();
      } else {
        currConsent = '';
      }
      final int currWait;
      if (listing[19].isNotEmpty) {
        currWait = int.parse(listing[19]);
      } else {
        currWait = 0;
      }
      final int currEnrollment;
      if (listing[17].isNotEmpty) {
        currEnrollment = int.parse(listing[17]);
      } else {
        currEnrollment = 0;
      }
      final termCode = int.parse(termYear + termMonth);
      final int classNumber = int.parse(listing[5]);
      final Term currTerm =
          Term.instances.firstWhere((each) => each.code == termCode);
      _instances.add(
        Class(
          currCourse,
          currTerm,
          int.parse(listing[18]), // Max enrollment
          MeetingTime.fromString(listing[21]), // schedule
          listing[22].replaceAll('/', '\n'), // Classroom
          currInstructors,
          currCampus,
          classNumber, // Class Number
          section,
          listing[27], //video
          currConsent, //consent
          currNotes, //specialnotes
          '\$$currFee', //fee
          //int.parse(listing[17]),
          currEnrollment, //enroll Count breaks credit test???
          currWait, //waitlist
          isOpen, //sstatus
        ),
      );
    }
  }

  void changeEnrollmentStatus() {
    isOpenForEnrollment = !isOpenForEnrollment;
  }

  void updateWaitlist(String updateType) {
    if (updateType == 'add') {
      waitlist = waitlist + 1;
    } else if (updateType == 'drop' && waitlist > 0) {
      waitlist = waitlist - 1;
    } else {
      throw 'waitlist out of bounds';
    }
  }

  String getCampus() => campus.code;

  String getCode() {
    return course.subject.code.toString();
  }

  String getVideo() {
    return video;
  }

  String getInstructors() {
    return instructors.map((e) => e.name).join('\n');
  }

  String getClN() {
    return classNumber.toString();
  }

  String getCoN() {
    return course.number.toString();
  }

  double getCredits() {
    return course.creditsMax;
  }

  // Below are filter functions, used in the query class to filter the results.

  bool includesStartTime(HourMinute? startTime) {
    if (startTime == null) {
      return true;
    }
    return schedule.startsAt(time: startTime);
  }

  bool includesEndTime(HourMinute? endTime) {
    if (endTime == null) {
      return true;
    }
    return schedule.endsAt(time: endTime);
  }

  bool includesDays(List<String> sList) {
    final List<String> scheduleValues = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final List<int> dayValues = [];
    final List<int> dayIndices = [1, 2, 3, 4, 5, 6, 7];
    for (final day in sList) {
      dayValues.add(scheduleValues.indexWhere((item) => item == day) + 1);
    }
    for (final index in dayValues) {
      if (!schedule.isAt(day: index)) {
        // if the listing does not include the day
        return false;
      }
      for (final mainIndex in dayIndices) {
        // Checking if the listing includes a day that is not in the search
        if (!dayValues.contains(mainIndex) && schedule.isAt(day: mainIndex)) {
          return false;
        }
      }
    }
    return true;
  }

  bool includesInstructor(String instructor) {
    if (instructor == '') {
      return true;
    } else {
      return instructors.any((each) => each.name.startsWith(instructor));
    }
  }

  bool includesGS(bool gs) {
    return !gs || course.isGeneralStudies;
  }

  bool includesOpen(bool status) {
    return !status || isOpenForEnrollment;
  }

  bool includesLevel(String level) {
    if (level == '' || level == 'Any') {
      return true;
    }
    return course.level == level;
  }

  bool includesCredits(String creditString) {
    final credits = getCredits();
    switch (creditString) {
      case '0':
        return credits == 0;
      case '1':
        return credits == 1;
      case '2':
        return credits == 2;
      case '3':
        return credits == 3;
      case '4':
        return credits == 4;
      case '>4':
        return credits > 4;
      default:
        return true;
    }
  }

  String getWList() {
    return waitlist.toString();
  }

  String getFee() {
    return fee;
  }

  String getTitle() {
    return course.title;
  }

  int getLineHeight() {
    return max(
      max(
        schedule.toString().split('\n').length,
        classroom.split('\n').length,
      ),
      max(
        getInstructors().split('\n').length,
        1,
      ),
    );
  }

  @override
  int compareTo(dynamic other) {
    return '${course.subject.code} ${course.number} ${term.code} $section'
        .compareTo(
      '${other.course.subject.code} ${other.course.number} ${other.term.code} ${other.section}',
    );
  }
}
