import 'package:schedule/campus.dart';
import 'package:schedule/course.dart';
import 'package:schedule/term.dart';
import 'package:schedule/instructor.dart';
import 'package:schedule/load_csv.dart';

class Class {
  Class(
    this.course,
    this.term,
    this.maxEnrollment,
    this.schedule,
    this.classroom,
    this.instructor,
    this.campus, [
    this.video = '',
    this.consent = '',
    this.specialNotes = '',
    this.fee = 0,
    this.currEnrollment = 0,
    this.waitlist = 0,
    this.section = 'A',
    this.isOpenForEnrollment = true,
  ]);

  Course course;
  Term term;
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

  static final _instances = <Class>{};

  static Set<Class> get instances {
    if (_instances.isEmpty) {
      Class._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    Course.getAllCourses();
    final classListFromCsv = getListFromCsv();
    classListFromCsv.removeAt(0);
    for (final listing in classListFromCsv) {
      final Course currCourse =
          Course.instances.firstWhere((each) => each.title == listing[14]);
      final Instructor currInstructor =
          Instructor.instances.firstWhere((each) => each.name == listing[23]);
      final Campus currCampus =
          Campus.instances.firstWhere((each) => each.code == listing[1]);
      final termYear = (listing[2] / 1000).truncate().toString() +
          (listing[2] % 2000).toString();
      var termMonth = '';
      var termFound = '';
      for (int i = 8; i <= 12; i++) {
        termFound = listing[i].toString();
        if (termFound != '') {
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
      final termCode = int.parse(termYear + termMonth);
      final Term currTerm =
          Term.instances.firstWhere((each) => each.code == termCode);
      _instances.add(
        Class(
          currCourse,
          currTerm,
          listing[18],
          listing[26],
          listing[22],
          currInstructor,
          currCampus,
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
}
