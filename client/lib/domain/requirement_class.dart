import 'package:client/domain/course.dart';

class Requirement {
  Requirement({
    required this.title,
    required this.status,
    required this.details,
  });
  final String title;
  final String status;
  final List<RequirementDetail> details;

  @override
  String toString() {
    return 'Requirement(title: $title, status: $status, details: $details)';
  }
}

class RequirementDetail {
  RequirementDetail({
    required this.description,
    required this.unitsRequired,
    required this.unitsCompleted,
    required this.unitsNeeded,
    required this.status,
  });
  final String description;
  final double unitsRequired;
  final double unitsCompleted;
  final double unitsNeeded;
  final bool status;

  @override
  String toString() {
    return 'RequirementDetail(description: $description, unitsRequired: $unitsRequired, unitsCompleted: $unitsCompleted, status: $status)';
  }
}

class Section {
  Section({
    required this.name,
    required this.requirements,
    required this.courses,
  });
  final String name;
  final List<Requirement> requirements;
  final List<Course> courses;

  @override
  String toString() {
    return 'Section(name: $name, requirements: $requirements, courses: $courses)';
  }
}
