import './department.dart';
import './subject.dart';
import 'package:schedule/load_csv.dart';

class Course {
  Department? department;
  Subject? subject;
  final String title;
  final int number;
  final String level;
  final int credits;
  final bool isGeneralStudies;

  Course(String departmentCode, String subjectCode, this.title, this.number,
      this.level, this.credits,
      [this.isGeneralStudies = false]) {
    var departments = Department.instances;
    department = departments.firstWhere((dept) => departmentCode == dept.code);
    var subjects = Subject.instances;
    subject = subjects.firstWhere((subj) => subjectCode == subj.code);
  }

  static final _instances = <Course>{};

  static get instances {
    if (_instances.isEmpty) {
      Course.getAllCourses();
    }
    return _instances;
  }

  static bool isNumeric(var value) {
    if (value == null) {
      return false;
    }
    if (value.runtimeType == int) {
      return true;
    }
    return double.tryParse(value) != null;
  }

  static void getAllCourses() {
    var classopenCSV = getListFromCsv();
    // Remove headers
    classopenCSV.removeAt(0);
    for (var value in classopenCSV) {
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
          : int.parse(classNumber
              .replaceAll(' ', '')
              .substring(0, classNumber[8].replaceAll(' ', '').length - 2));
      var level = classNumber > 300 ? 'upper' : 'lower';
      _instances.add(Course(value[3], value[7], value[14], classNumber, level,
          int.tryParse(value[16]) ?? 0, value[6] == 'GS'));
    }
  }
}
