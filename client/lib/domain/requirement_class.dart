import 'package:client/domain/course.dart';

enum RequirementType {
  minTotal,
  minUpper,
  min4Yr,
}

class Requirement {
  Requirement({
    required this.title,
    required this.status,
    required this.details,
  });
  final String title;
  final bool status;
  final List<RequirementDetail> details;
}

class RequirementDetail {
  RequirementDetail({
    required this.description,
    required this.unitsRequired,
    required this.unitsCompleted,
    required this.status,
  });
  final String description;
  final double unitsRequired;
  final double unitsCompleted;
  final bool status;
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
}
