class Audit {
  Audit({
    required this.studentInfo,
    required this.requirements,
    required this.sections,
  });
  StudentInfo studentInfo;
  List<Requirement> requirements;
  List<Section> sections;
}

class StudentInfo {
  StudentInfo({
    required this.name,
    required this.studentId,
    required this.programStart,
    required this.status,
  });
  String name;
  String studentId;
  String programStart;
  Map<String, String> status;
}

class Requirement {
  Requirement({
    required this.title,
    required this.status,
    required this.details,
  });
  String title;
  bool status;
  List<RequirementDetail> details;
}

class RequirementDetail {
  RequirementDetail({
    required this.description,
    required this.unitsRequired,
    required this.unitsCompleted,
    required this.status,
  });
  String description;
  double unitsRequired;
  double unitsCompleted;
  bool status;
}

class Section {
  Section({
    required this.name,
    required this.requirements,
    required this.courses,
  });
  String name;
  List<Requirement> requirements;
  List<Course> courses;
}

class Course {
  Course({
    required this.term,
    required this.subject,
    required this.catalogNumber,
    required this.title,
    required this.grade,
    required this.units,
    required this.type,
  });
  String term;
  String subject;
  String catalogNumber;
  String title;
  String grade;
  double units;
  String type;
}
