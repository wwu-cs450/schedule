import 'package:csv/csv.dart';
import 'package:schedule_client/domain/sample_csv.dart'
    if (kDebugMode) 'package:schedule_client/domain/schedule.dart';

class CSVHandler {
  // cache containing data from schedule.dart as list of list of strings
  static List<List<String>> _data = List.empty();
  static bool _usingTest = false;

  static List<List<String>> get data => _data;

  // empty data
  static void empty() {
    _data = List.empty();
  }

  // returns the csv from schedule.dart as a list of list of strings
  static Future<List<List<String>>> listFromCsv({bool test = false}) async {
    if (_data.isNotEmpty && _usingTest == test) {
      return _data;
    }
    _usingTest = test;
    final String csvFile = await getSchedule();

    _data = const CsvToListConverter().convert<String>(
      csvFile,
      fieldDelimiter: ',',
      eol: '\n',
      convertEmptyTo: '',
      shouldParseNumbers: false,
    );
    return _data;
  }

  // returns a csv from a list of lists of strings
  static String csvFromList(List<List<String>> list) {
    return const ListToCsvConverter().convert(
      list,
      fieldDelimiter: ',',
      eol: '\n',
    );
  }
}
