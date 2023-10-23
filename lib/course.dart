import './department.dart';
import './subject.dart';

class Course {
  Department? department;
  Subject? subject;
  final String title;
  final String number;
  final String level;
  final int credits;
  final bool isGeneralStudies;

  Course(String departmentCode, String subjectCode, this.title, this.number,
      this.level, this.credits,
      [this.isGeneralStudies = false]) {
    Department.initialize();
    var departments = Department.instances;
    department =
        departments.where((dept) => departmentCode == dept.code).toList()[0];

    Subject.initialize();
    var subjects = Subject.instances;
    subject = subjects.where((subj) => subjectCode == subj.code).toList()[0];
  }
}
