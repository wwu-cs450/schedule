import 'package:csv/csv.dart';
import 'package:schedule_client/domain/schedule.dart';

class CSVHandler {
  // cache containing data from schedule.dart as list of list of strings
  static List<List<String>> _data = List.empty();
  static List<List<String>> get data => _data;

  // empty data
  static void empty() {
    _data = List.empty();
  }

  // returns the csv from schedule.dart as a list of list of strings
  static Future<List<List<String>>> listFromCsv() async {
    String csvFile = '';

    // test bool for testing (consistency regardless of updated data)

    // remove header line
    csvFile =
        (await getSchedule()).replaceFirst(RegExp(r'^.*(\r\n|\r|\n)'), '');

    _data = const CsvToListConverter().convert<String>(
      csvFile,
      fieldDelimiter: '<',
      //textDelimiter: ' ',
      eol: '\n',
      convertEmptyTo: '',
      shouldParseNumbers: false,
    );
    return _data;
  }
}
