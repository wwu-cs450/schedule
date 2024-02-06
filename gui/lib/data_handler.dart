import 'package:gui/csv_handler.dart';
import 'package:gui/html_handler.dart';

class DataHandler {
  static const bool _useCsv = true; //Default: Using CSV

  // cache
  static List<List<String>> _data = List.empty();
  static bool _usingCsv = _useCsv;
  static bool _usingTest = false;

  static List<List<String>> get data => _data;
  static bool get usingCsv => _usingCsv;

  // empty data
  static void empty() {
    _data = List.empty();
  }

  // use this to get data from central place (either csv for html)
  static Future<List<List<String>>> fetchData({
    bool useCsv = _useCsv,
    bool test = false,
  }) async {
    if (_data.isEmpty || _usingCsv != useCsv || _usingTest != test) {
      _usingCsv = useCsv;
      _usingTest = test;
      if (useCsv) {
        //fetching new data from csv
        _data = CSVHandler.listFromCsv(test: test);
      } else {
        //fetching new data from html
        _data = await HTMLHandler.fetchListFromHtml(test: test);
      }
    }
    return _data;
  }
}
