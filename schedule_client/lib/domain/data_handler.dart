import 'package:schedule_client/domain/csv_handler.dart';

class DataHandler {
  // cache
  static List<List<String>> _data = List.empty();

  static List<List<String>> get data => _data;

  // empty data
  static void empty() {
    _data = List.empty();
  }

  // use this to get data from central place (either csv for html)
  static Future<List<List<String>>> fetchData({
    bool test = false,
  }) async {
    _data = await CSVHandler.listFromCsv(test: test);
    return _data;
  }
}
