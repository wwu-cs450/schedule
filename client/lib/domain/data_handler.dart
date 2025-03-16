import 'package:client/domain/csv_handler.dart';

class DataHandler {
  // cache
  static List<List<String>> _data = List.empty();
  static String _dateTime = '';

  static List<List<String>> get data => _data;
  static String get dateTime => _dateTime;

  // empty data
  static void empty() {
    _data = List.empty();
    _dateTime = '';
  }

  // use this to get data from central place (either csv for html)
  static Future<void> fetchData({bool test = false}) async {
    _data = await CSVHandler.listFromCsv(test: test);
    _dateTime = await CSVHandler.getDateTime(test: test);
  }
}
