enum CompletionStatus {
  passed,
  failed,
  withdrew,
  incomplete,
  registered
  ;

  String toDisplayString() {
    switch (this) {
      case CompletionStatus.passed:
        return 'Passed';
      case CompletionStatus.failed:
        return 'Failed';
      case CompletionStatus.withdrew:
        return 'Withdrew';
      case CompletionStatus.incomplete:
        return 'Incomplete';
      case CompletionStatus.registered:
        return 'Registered';
    }
  }
}

class CompletedCourse {
  CompletedCourse({
    required this.course,
    required this.courseTitle,
    required this.grade,
    required this.credits,
    required this.term,
  }) : status = _determineStatus(grade);

  // JSON deserialization
  factory CompletedCourse.fromJson(Map<String, dynamic> json) {
    return CompletedCourse(
      course: json['course'] as String,
      courseTitle: json['courseTitle'] as String,
      grade: json['grade'] as String,
      credits: (json['credits'] as num).toDouble(),
      term: json['term'] as String,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'courseTitle': courseTitle,
      'grade': grade,
      'credits': credits,
      'term': term,
      'status': status.toDisplayString(),
    };
  }

  final String course;
  final String courseTitle;
  final String grade;
  final double credits;
  final String term;
  final CompletionStatus status;

  // Determine status based on grade
  static CompletionStatus _determineStatus(String grade) {
    if (grade == 'I' || grade == 'I*' || grade == 'IP' || grade == 'IP*') {
      return .incomplete;
    } else if (grade == 'W' || grade == 'X' || grade == 'Z') {
      return .withdrew;
    } else if (grade == 'NC' || grade == 'F' || grade == 'D-') {
      return .failed;
    } else if (grade == 'NR') {
      return .registered;
    } else {
      return .passed;
    }
  }

  @override
  String toString() {
    return '\nCompletedClass(\n'
        '  course: $course,\n'
        '  courseTitle: $courseTitle,\n'
        '  grade: $grade,\n'
        '  credits: $credits,\n'
        '  term: $term,\n'
        '  status: $status,\n'
        ')';
  }
}
