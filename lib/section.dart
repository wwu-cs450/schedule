import './campus.dart';
import './course.dart';
import './term.dart';
import './instructor.dart';

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
  Instructor instructor;
  Campus? campus;
  String video;
  String consent;
  String specialNotes;

  static final _instances = <Section>{};

  static get instances {
    if (_instances.isEmpty) {
      Section._initialize();
    }
    return _instances;
  }

// Fake data. Should be replaced by #11
  static void _initialize() {
    var james =
        Instructor.instances.firstWhere((each) => each.name == 'James Foster');
    var john =
        Instructor.instances.firstWhere((each) => each.name == 'John Foster');
    for (var i = 0; i < 5; i++) {
      var cs141 = Course(
          'CPTR', 'CPTR', 'Fundamentals of Programming I', 200 - i, 'lower', 4);
      var cs141a = Section(cs141, 2239, 30, 'MWRF', 'KRH 348', james, 'CP');
      _instances.add(cs141a);
    }
    for (var i = 0; i < 5; i++) {
      var math181 = Course('MATH', 'MATH', 'Calculus I', 200 - i, 'lower', 4);
      var math181a = Section(math181, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
      _instances.add(math181a);
    }
  }

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
