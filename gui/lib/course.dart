import 'package:gui/department.dart';
import 'package:gui/data_handler.dart';
import 'package:gui/subject.dart';

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
    final scheduleData = DataHandler.data;
    for (final classData in scheduleData) {
      final int courseNumberOnly;
      // Class number is not specified in one spot, it is specified based on the quarter, Summer, Fall, Winter, Spring, or Summer2
      var courseNumber = '';
      if (classData[8] != '') {
        courseNumber = classData[8].toString();
      } else if (classData[9] != '') {
        courseNumber = classData[9].toString();
      } else if (classData[10] != '') {
        courseNumber = classData[10].toString();
      } else if (classData[11] != '') {
        courseNumber = classData[11].toString();
      } else if (classData[12] != '') {
        courseNumber = classData[12].toString();
      } else {
        courseNumber = '0';
      }

      courseNumber = courseNumber.replaceAll(' ', '');
      courseNumberOnly =
          int.parse(courseNumber.replaceAll(RegExp('[^0-9]'), ''));
      late String level;
      if (courseNumberOnly < 300) {
        level = 'Lower';
      } else if (courseNumberOnly > 499) {
        level = 'Grad';
      } else {
        level = 'Upper';
      }

      final department = Department.departmentwithCode(classData[3]);
      final subject = Subject.subjectWithCode(classData[7]);
      _instances.add(
        Course(
          department,
          subject,
          classData[14],
          courseNumber,
          level,
          creditSplit(classData[15].toString())[0],
          creditSplit(classData[15].toString())[1],
          classData[6] == 'GS',
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
