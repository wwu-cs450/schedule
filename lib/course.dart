import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';
import 'package:schedule/load_csv.dart';

class Course {
  Course(
    String departmentCode,
    String subjectCode,
    this.title,
    this.number,
    this.level,
    this.credits, [
    this.isGeneralStudies = false,
  ]) {
    final departments = Department.instances;
    department = departments.firstWhere((dept) => departmentCode == dept.code);
    final subjects = Subject.instances;
    subject = subjects.firstWhere((subj) => subjectCode == subj.code);
  }
  Department? department;
  Subject? subject;
  Term? term;
  final String title;
  final int number;
  final String level;
  final int credits;
  final bool isGeneralStudies;

  static final _instances = <Course>{};

  static Set<Course> get instances {
    if (_instances.isEmpty) {
      Course.getAllCourses();
    }
    return _instances;
  }

  static bool isNumeric(dynamic value) {
    if (value == null) {
      return false;
    }
    if (value.runtimeType == int) {
      return true;
    }
    return double.tryParse(value) != null;
  }

  static void getAllCourses() {
    final classopenCSV = getListFromCsv();
    // Remove headers
    classopenCSV.removeAt(0);
    for (final value in classopenCSV) {
      dynamic classNumber;
      // Class number is not specified in one spot, it is specified based on the quarter, Summer, Fall, Winter, Spring, Summer2
      if (value[8] != '') {
        classNumber = value[8];
      } else if (value[9] != '') {
        classNumber = value[9];
      } else if (value[10] != '') {
        classNumber = value[10];
      } else if (value[11] != '') {
        classNumber = value[11];
      } else if (value[12] != '') {
        classNumber = value[12];
      } else {
        classNumber = 0;
      }
      // Some class numbers are integers, some are strings, formatted with a lot of extra spaces.
      classNumber = (isNumeric(classNumber))
          ? classNumber
          : int.parse(
              classNumber
                  .replaceAll(' ', '')
                  .substring(0, classNumber.replaceAll(' ', '').length - 2),
            );
      final level = classNumber > 300 ? 'upper' : 'lower';
      _instances.add(
        Course(
          value[3],
          value[7],
          value[14],
          classNumber,
          level,
          int.tryParse(value[16]) ?? 0,
          value[6] == 'GS',
        ),
      );
    }
  }
}
