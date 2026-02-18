import 'package:common/completed_course.dart';
import 'package:common/course.dart';

/// Defines a student's graduation requirements, which includes any majors and minors.
class GraduationRequirements {
  GraduationRequirements({
    required this.majorRequirements,
    this.minorRequirements,
  });

  List<Major> majorRequirements;
  List<Minor>? minorRequirements;

  List<Course> get allRequiredCourses {
    final courses = <Course>{};
    for (final major in majorRequirements) {
      courses.addAll(major.requiredCourses);
    }
    if (minorRequirements != null) {
      for (final minor in minorRequirements!) {
        courses.addAll(minor.requiredCourses);
      }
    }
    return courses.toList();
  }

  List<Course> getRemainingRequiredCourses(List<CompletedCourse> completedCourses) {
    final requiredCourses = allRequiredCourses;
    final remainingCourses = <Course>{};
    for (final course in requiredCourses) {
      if (!completedCourses.contains(course)) {
        remainingCourses.add(course);
      }
    }
    return remainingCourses.toList();
  }
}

/// Represents a major and its associated graduation requirements
class Major {
  Major({
    required this.name,
    required this.bulletinYear,
    required this.requiredCourses,
  });

  String name;
  String bulletinYear;
  List<Course> requiredCourses;
}

/// Represents a minor and its associated graduation requirements
class Minor {
  Minor({
    required this.name,
    required this.bulletinYear,
    required this.requiredCourses,
  });

  String name;
  String bulletinYear;
  List<Course> requiredCourses;
}

final computerScienceBS_2023_2024 = Major(
  name: 'Computer Science Major (Bachelor of Science)',
  bulletinYear: '2023-2024',
  requiredCourses: [
    Course(
      courseCode: 'CPTR 108',
      courseTitle: 'The Art and Practice of Computer Science',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      courseCode: 'CPTR 141',
      courseTitle: 'Fundamentals of Programming I',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 142',
      courseTitle: 'Fundamentals of Programming II',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 242',
      courseTitle: 'Sequential and Parallel Data Structures and Algorithms',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 245',
      courseTitle: 'Software Development',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 280',
      courseTitle: 'Computer Organization and Assembly Language',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      courseCode: 'CPTR 308',
      courseTitle: 'Social, Legal, and Ethical Issues for Computing Technology',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 352',
      courseTitle: 'Operating Systems',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 354',
      courseTitle: 'Compilers and Languages',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 396',
      courseTitle: 'Internship and Career Readiness Seminar',
      creditsMin: 1.0,
      creditsMax: 1.0,
    ),
    Course(
      courseCode: 'CPTR 450',
      courseTitle: 'Software Engineering',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      courseCode: 'CPTR 454',
      courseTitle: 'Design and Analysis of Algorithms',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'CPTR 496',
      courseTitle: 'Senior Project I',
      creditsMin: 1.0,
      creditsMax: 1.0,
    ),
    Course(
      courseCode: 'CPTR 497',
      courseTitle: 'Senior Project II',
      creditsMin: 2.0,
      creditsMax: 2.0,
    ),
    Course(
      courseCode: 'CPTR 498',
      courseTitle: 'Senior Project III',
      creditsMin: 2.0,
      creditsMax: 2.0,
    ),
    Course(
      courseCode: 'ENGR 354',
      courseTitle: 'Digital Logic',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      courseCode: 'MATH 171',
      courseTitle: 'Calculus I',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'MATH 172',
      courseTitle: 'Calculus II',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'MATH 273',
      courseTitle: 'Calculus III',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'MATH 215',
      courseTitle: 'Data Analysis',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'MATH 250',
      courseTitle: 'Discrete Mathematics',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      courseCode: 'MATH 239',
      courseTitle: 'Introduction to Linear Algebra',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
  ],
);
