import 'package:schedule/department.dart';
import 'package:schedule/data_handler.dart';
import 'package:schedule/subject.dart';

class Course implements Comparable {
  Course(
    this.department,
    this.subject,
    this.title,
    this.number,
    this.level,
    this.creditsMin,
    this.creditsMax, [
    this.isGeneralStudies = false,
  ]);
  final Department department;
  final Subject subject;
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

  // Handle date format
  static List<double> creditSplit(String input) {
    late double creditsMin;
    late double creditsMax;
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthNum = months.indexWhere((each) => input.contains(each)) + 1;
    if (double.tryParse(input) != null) {
      creditsMin = double.tryParse(input)!;
      creditsMax = creditsMin;
    } else if (monthNum > 0) {
      creditsMax = double.tryParse(input.split('-')[0]) ?? 0;
      creditsMin = monthNum.toDouble();
    } else if (input.contains('-') && input.length >= 3) {
      creditsMin = double.tryParse(input.split('-')[0]) ?? 0;
      creditsMax = double.tryParse(input.split('-')[1]) ?? creditsMin;
    } else {
      throw FormatException(
        "Neither a single number nor of the format 'n-n' nor of the format 'n-month' : ",
        input,
      );
    }
    return [creditsMin, creditsMax];
  }

  static void getAllCourses() {
    final classData = DataHandler.data;
    for (final value in classData) {
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
      final department = Department.departmentwithCode(value[3]);
      final subject = Subject.subjectWithCode(value[7]);
      _instances.add(
        Course(
          department,
          subject,
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

  @override
  int compareTo(dynamic other) {
    return '$number ${subject.code} $title'
        .compareTo('${other.number} ${other.subject.code} ${other.title} ');
  }
}
