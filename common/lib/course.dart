/// Defines a course that can be taken.
///
/// EXAMPLES
/// `course = 'CPTR 108'`
/// `courseTitle = 'The Art and Practice of Computer Science'`
/// `creditsMin = 3.0`
/// `creditsMax = 3.0`
class Course {
  Course({
    required this.course,
    required this.courseTitle,
    required this.creditsMin,
    required this.creditsMax,
  });

  final String course;
  final String courseTitle;
  final double creditsMin;
  final double creditsMax;

  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'courseTitle': courseTitle,
      'creditsMin': creditsMin,
      'creditsMax': creditsMax,
    };
  }
}
