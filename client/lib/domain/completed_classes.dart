// completed_classes.dart

import 'package:client/domain/course.dart';

class CompletedClass {
  CompletedClass({
    required this.subject,
    required this.classNumber,
    required this.course,
    required this.credits,
    required this.term,
    required String grade,
  }) : status = _determineStatus(grade);

  final String subject;
  final String classNumber;
  final String course;
  final double credits;
  final String term;
  final String status;

  // Determine status based on grade
  static String _determineStatus(String grade) {
    if (grade == 'N/A') {
      return 'N/A';
    }
    if (grade == 'W') {
      return 'Withdrew';
    }
    if (grade == 'F' || grade == 'D-' || grade == 'D' || grade == 'D+') {
      return 'Failed';
    }
    return 'Passed';
  }
}

class CompletedClasses {
  CompletedClasses({required this.classes});

  final List<CompletedClass> classes;

  bool haveTaken(Course course) {
    return classes.any(
      (each) =>
          each.subject == course.subject.code &&
          each.classNumber == course.number,
    );
  }
}
