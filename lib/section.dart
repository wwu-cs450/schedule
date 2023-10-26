import './campus.dart';

import './course.dart';

import './term.dart';

// import './course.dart';

class Section {
  Course course;
  Term? term;
  String section;
  int maxEnrollment;
  int currEnrollment;
  bool isOpenForEnrollment;
  int waitlist;
  int fee;
  String schedule;
  String classroom;
  String instructor;
  Campus? campus;
  String video;
  String consent;
  String specialNotes;

  Section(this.course, int termCode, this.maxEnrollment, this.schedule,
      this.classroom, this.instructor, String campusCode,
      [this.video = '',
      this.consent = '',
      this.specialNotes = '',
      this.fee = 0,
      this.currEnrollment = 0,
      this.waitlist = 0,
      this.section = 'A',
      this.isOpenForEnrollment = true]) {
    var campuses = Campus.instances;
    campus = campuses.where((camp) => campusCode == camp.code).toList()[0];
    var terms = Term.instances;
    term = terms.where((term) => termCode == term.code).toList()[0];
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
}
