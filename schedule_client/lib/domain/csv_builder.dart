import 'package:csv/csv.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/csv_handler.dart';

String createCSV() {
  final List<Class> classes = [];
  for (final element in Class.instances) {
    if (element.saved) {
      classes.add(element);
    }
  }
  final List<List<String>> toCSV =
      List.generate(classes.length + 1, (index) => ['', '', '', '']);
  toCSV[0][0] = 'Class Number';
  toCSV[0][1] = 'Subject';
  toCSV[0][2] = 'Class name';
  toCSV[0][3] = 'Time';
  for (int i = 0; i < classes.length; i++) {
    toCSV[i + 1][0] = classes[i].classNumber.toString();
    toCSV[i + 1][1] = classes[i].course.subject.name;
    toCSV[i + 1][2] = classes[i].course.title;
    toCSV[i + 1][3] = classes[i].schedule.toString(is24hr: false);
  }
  String scheduleCSV = '';
  scheduleCSV = CSVHandler.csvFromList(toCSV);
  return scheduleCSV;
}

void reloadSavedClasses(String scheduleCSV) {
  final list = const CsvToListConverter().convert(scheduleCSV);
  for (final element in Class.instances) {
    for (int i = 0; i < list.length; i++) {
      if (element.classNumber.toString() == list[i][0] &&
          element.course.title == list[i][2]) {
        element.saved = true;
      }
    }
  }
}
