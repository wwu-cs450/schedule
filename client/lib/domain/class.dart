import 'dart:math';

import 'package:client/domain/campus.dart';
import 'package:client/domain/course.dart';
import 'package:client/domain/handlers/class_storage.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/instructor.dart';
import 'package:client/domain/meeting_time.dart';
import 'package:client/domain/models/general_requirements.dart';
import 'package:client/domain/term.dart';

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

  final classStorage = ClassStorage();

  static final _instances = <Class>{};

  void changeEnrollmentStatus() {
    isOpenForEnrollment = !isOpenForEnrollment;
  }

  // new method get emptyclassrooms takes one arguement of day, hour and minute and returns classrooms that are empty at that time
  static List<String> getAvailableClassrooms(MeetingTime schedule) {
    final List<String> availableClassrooms = [];
    final Set<String> occupiedClassrooms = instances
        .where((classInstance) => classInstance.schedule.overlaps(schedule))
        .map((classInstance) => classInstance.classroom)
        .toSet();
    for (final classroom in getAllClassrooms()) {
      if (!occupiedClassrooms.contains(classroom)) {
        availableClassrooms.add(classroom);
      }
    }
    return availableClassrooms;
  }

  static List<String> getAllClassrooms() {
    final Set<String> classrooms = {};
    for (final classInstance in instances) {
      classrooms.add(classInstance.classroom);
    }
    return classrooms.toList();
  }

  String getCampus() => campus.code;

  String getCode() => course.subject.code.toString();

  String getInstructors() => instructors.map((e) => e.name).join('\n');

  String getClN() => classNumber.toString();

  String getCoN() => course.number.toString();

  double getCredits() => course.creditsMax;

  String getVideo() => video;

  static void _initialize() {
    // convert CSV data to class instances
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
       9  WWU_FAL
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
    Course.getAllCourses();
    final classData = DataHandler.data;
    for (final listing in classData) {
      final courseNumber =
          '${listing[8].trim()}'
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
        currCampus = Campus.instances.firstWhere(
          (each) => each.code == listing[1],
        );
      } catch (e) {
        // print('Campus not found: "${listing[1]}"');
        rethrow;
      }
      var termYear =
          (int.parse(listing[2]) / 1000).truncate().toString() +
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
      final Term currTerm = Term.instances.firstWhere(
        (each) => each.code == termCode,
      );
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

  static Set<Class> get instances {
    if (_instances.isEmpty) {
      Class._initialize();
    }
    return _instances;
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

  bool includesDays(List<String> sList, {String logic = 'Any'}) {
    // If no days are selected, show all classes
    if (sList.isEmpty) {
      return true;
    }

    // If all days are selected with Any logic, show all classes
    final allDays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    if (logic == 'Any' &&
        sList.length == allDays.length &&
        sList.toSet().containsAll(allDays)) {
      return true;
    }

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
    for (final day in sList) {
      dayValues.add(scheduleValues.indexWhere((item) => item == day) + 1);
    }

    if (logic == 'Any') {
      // Any: class must meet on at least one of the selected days
      for (final index in dayValues) {
        if (schedule.isAt(day: index)) {
          return true;
        }
      }
      return false;
    } else if (logic == 'All') {
      // All: class must meet on all selected days (can also meet on other days)
      for (final index in dayValues) {
        if (!schedule.isAt(day: index)) {
          // if the listing does not include the day
          return false;
        }
      }
      return true;
    } else {
      // Exclude: class must NOT meet on any of the selected days
      for (final index in dayValues) {
        if (schedule.isAt(day: index)) {
          return false;
        }
      }
      return true;
    }
  }

  bool includesInstructor(String instructor) {
    if (instructor == '') {
      return true;
    } else {
      return instructors.any(
        (each) => each.name.toLowerCase().contains(instructor.toLowerCase()),
      );
    }
  }

  bool includesGS(bool gs) {
    return !gs || course.isGeneralStudies;
  }

  bool includesOpen(bool status) {
    return !status || isOpenForEnrollment;
  }

  bool includesNotTaken(bool notTaken) {
    return !notTaken || !classStorage.haveTaken(course);
  }

  bool includesNoConflict(bool hideConflicting) {
    if (!hideConflicting) {
      return true;
    }
    if (saved) {
      return true;
    }
    final savedForTerm = Class.instances
        .where((c) => c.saved && c != this && c.term == term)
        .toList();
    if (savedForTerm.isEmpty) {
      return true;
    }
    return !savedForTerm.any((c) => schedule.overlaps(c.schedule));
  }

  bool includesLevel(String level) {
    if (level.isEmpty || level == 'Any' || level == 'Lower,Upper,Grad') {
      return true;
    }
    // Handle comma-separated multi-select
    final selectedLevels = level.split(',');
    return selectedLevels.contains(course.level);
  }

  bool includesLevels(List<String> levels) {
    if (levels.isEmpty ||
        (levels.length == 3 &&
            levels.contains('Lower') &&
            levels.contains('Upper') &&
            levels.contains('Grad'))) {
      return true;
    }
    return levels.contains(course.level);
  }

  bool includesCredits(String creditString) {
    final credits = getCredits();

    // Handle default/all cases
    if (creditString.isEmpty ||
        creditString == 'Any' ||
        creditString == '0,1,2,3,4,>4') {
      return true;
    }

    // Handle comma-separated multi-select
    final selectedCredits = creditString.split(',');

    for (final selected in selectedCredits) {
      switch (selected) {
        case '0':
          if (credits == 0) {
            return true;
          }
        case '1':
          if (credits == 1) {
            return true;
          }
        case '2':
          if (credits == 2) {
            return true;
          }
        case '3':
          if (credits == 3) {
            return true;
          }
        case '4':
          if (credits == 4) {
            return true;
          }
        case '>4':
          if (credits > 4) {
            return true;
          }
      }
    }
    return false;
  }

  bool includesCreditsFromList(List<String> creditsList) {
    if (creditsList.isEmpty ||
        (creditsList.length == 6 &&
            creditsList.contains('0') &&
            creditsList.contains('1') &&
            creditsList.contains('2') &&
            creditsList.contains('3') &&
            creditsList.contains('4') &&
            creditsList.contains('>4'))) {
      return true;
    }

    final credits = getCredits();

    for (final selected in creditsList) {
      switch (selected) {
        case '0':
          if (credits == 0) {
            return true;
          }
        case '1':
          if (credits == 1) {
            return true;
          }
        case '2':
          if (credits == 2) {
            return true;
          }
        case '3':
          if (credits == 3) {
            return true;
          }
        case '4':
          if (credits == 4) {
            return true;
          }
        case '>4':
          if (credits > 4) {
            return true;
          }
      }
    }
    return false;
  }

  bool includesGeneralCategories(List<GeneralCategory> categories) {
    // If no categories are selected, include all classes
    if (categories.isEmpty) {
      return true;
    }

    // Check if this course matches any of the selected categories
    final courseCode = '${course.subject.code} ${course.number}';

    for (final category in categories) {
      for (final option in category.options) {
        if (option.course == courseCode) {
          return true;
        }
      }
    }

    return false;
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
      max(schedule.toString().split('\n').length, classroom.split('\n').length),
      max(getInstructors().split('\n').length, 1),
    );
  }

  @override
  int compareTo(dynamic other) {
    return '${course.subject.code} ${course.number} ${term.code} $section'
        .compareTo(
          '${other.course.subject.code} ${other.course.number} ${other.term.code} ${other.section}',
        );
  }

  @override
  String toString() {
    return '${course.subject.code} ${course.number} $section';
  }
}
