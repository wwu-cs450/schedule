import 'package:common/course.dart';

/// Base class for items that can appear in a requirement list
sealed class RequirementItem {}

/// Wrapper for a single required course
class CourseRequirement extends RequirementItem {
  CourseRequirement(this.course);
  final Course course;
}

/// Represents a bucket of courses that a student can choose from to fulfill a requirement
class CourseBucket extends RequirementItem {
  CourseBucket({
    required this.creditRequirement,
    required this.courseOptions,
  });

  int creditRequirement;
  List<Course> courseOptions;
}
