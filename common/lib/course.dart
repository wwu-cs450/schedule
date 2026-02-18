/// Defines a course that can be taken.
/// 
/// EXAMPLES
/// `courseCode = 'CPTR 108'`
/// `courseTitle = 'The Art and Practice of Computer Science'`
/// `creditsMin = 3.0`
/// `creditsMax = 3.0`
class Course {
  Course({
    required this.courseCode,
    required this.courseTitle,
    required this.creditsMin,
    required this.creditsMax,
  });

  final String courseCode;
  final String courseTitle;
  final double creditsMin;
  final double creditsMax;
}
