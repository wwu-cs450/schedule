import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/load_csv.dart';

class Course {
  Course(
    String departmentCode,
    String subjectCode,
    this.title,
    this.number,
    this.level,
    this.creditsMin,
    this.creditsMax, [
    this.isGeneralStudies = false,
  ]) {
    final departments = Department.instances;
    department = departments.firstWhere((dept) => departmentCode == dept.code);
    final subjects = Subject.instances;
    subject = subjects.firstWhere((subj) => subjectCode == subj.code);
  }
  Department? department;
  Subject? subject;
  final String title;
  final String number;
  final String level;
  final double creditsMin;
  final double creditsMax;
  final bool isGeneralStudies;

  static final _instances = <Course>{};

  static Set<Course> get instances {
    if (_instances.isEmpty) {
      Course.getAllCourses();
    }
    return _instances;
  }

  static List<double> creditSplit(String input) {
    late double creditsMin;
    late double creditsMax;
    if (double.tryParse(input) != null) {
      creditsMin = double.tryParse(input)!;
      creditsMax = creditsMin;
    } else if (input.contains('-') && input.length >= 3) {
      creditsMin = double.tryParse(input.split('-')[0]) ?? 0;
      creditsMax = double.tryParse(input.split('-')[1]) ?? creditsMin;
    } else {
      throw FormatException(
        "Neither a single number nor of the format 'n-n' : ",
        input,
      );
    }
    return [creditsMin, creditsMax];
  }

  static void getAllCourses() {
    final classopenCSV = getListFromCsv();
    // Remove headers
    classopenCSV.removeAt(0);
    for (final value in classopenCSV) {
      String courseNumber;
      final String courseNumberOnly;
      // Class number is not specified in one spot, it is specified based on the quarter, Summer, Fall, Winter, Spring, or Summer2
      if (value[8] != '') {
        courseNumber = value[8].toString();
      } else if (value[9] != '') {
        courseNumber = value[9].toString();
      } else if (value[10] != '') {
        courseNumber = value[10].toString();
      } else if (value[11] != '') {
        courseNumber = value[11].toString();
      } else if (value[12] != '') {
        courseNumber = value[12].toString();
      } else {
        courseNumber = '0';
      }

      courseNumber = courseNumber.replaceAll(' ', '');
      courseNumberOnly = courseNumber.replaceAll(RegExp('[^0-9]'), '');
      final level = int.parse(courseNumberOnly) > 300 ? 'upper' : 'lower';

      _instances.add(
        Course(
          value[3],
          value[7],
          value[14],
          courseNumber,
          level,
          creditSplit(value[15].toString())[0],
          creditSplit(value[15].toString())[1],
          value[6] == 'GS',
        ),
      );
    }
  }
}
