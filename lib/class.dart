import 'package:schedule/campus.dart';
import 'package:schedule/course.dart';
import 'package:schedule/term.dart';
import 'package:schedule/instructor.dart';

class Class {
  Class(
    this.course,
    int termCode,
    this.maxEnrollment,
    this.schedule,
    this.classroom,
    this.instructor,
    String campusCode, [
    this.video = '',
    this.consent = '',
    this.specialNotes = '',
    this.fee = 0,
    this.currEnrollment = 0,
    this.waitlist = 0,
    this.section = 'A',
    this.isOpenForEnrollment = true,
  ]) {
    final campuses = Campus.instances;
    campus = campuses.where((camp) => campusCode == camp.code).toList()[0];
    final terms = Term.instances;
    term = terms.where((term) => termCode == term.code).toList()[0];
  }
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

  static final _instances = <Class>{};

  static Set<Class> get instances {
    if (_instances.isEmpty) {
      Class._initialize();
    }
    return _instances;
  }

// Fake data. Should be replaced by #11
  static void _initialize() {
    final james =
        Instructor.instances.firstWhere((each) => each.name == 'James Foster');
    final john =
        Instructor.instances.firstWhere((each) => each.name == 'John Foster');
    for (var i = 0; i < 5; i++) {
      final cs141 = Course(
        'CPTR',
        'CPTR',
        'Fundamentals of Programming I',
        200 - i,
        'lower',
        4,
      );
      final cs141a = Class(cs141, 2239, 30, 'MWRF', 'KRH 348', james, 'CP');
      _instances.add(cs141a);
    }
    for (var i = 0; i < 5; i++) {
      final math181 = Course('MATH', 'MATH', 'Calculus I', 200 - i, 'lower', 4);
      final math181a = Class(math181, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
      _instances.add(math181a);
    }
    final relb = Course('RELB', 'RELB', 'Ministry of Jesus', 104, 'lower', 4);
    final relb1 = Class(relb, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(relb1);
    final relh =
        Course('RELB', 'RELH', 'Biblical Archaeology', 205, 'lower', 4);
    final relh1 = Class(relh, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(relh1);
    final relm = Course(
      'RELB',
      'RELM',
      'Intro to Cross-Cultural Ministry',
      233,
      'lower',
      4,
    );
    final relm1 = Class(relm, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(relm1);
    final relp =
        Course('RELB', 'RELP', 'Intro to Faith & Ministry', 131, 'lower', 4);
    final relp1 = Class(relp, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(relp1);
    final relt = Course('RELB', 'RELT', 'Christian Beliefs', 202, 'lower', 4);
    final relt1 = Class(relt, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(relt1);
    final serv = Course(
      'RELB',
      'SERV',
      'Community Engagement–Churches',
      305,
      'upper',
      4,
    );
    final serv1 = Class(serv, 2239, 30, 'MWRF', 'KRH 328', john, 'CP');
    _instances.add(serv1);
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
