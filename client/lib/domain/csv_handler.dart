import 'package:client/domain/sample_csv.dart';
import 'package:client/domain/sample_txt.dart';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;

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
    try {
      String csvFile;
      if (test) {
        csvFile = await getSample();
      } else {
        final response = await html.HttpRequest.request(
          'assets/class_data.csv',
          method: 'GET',
        );
        if (response.status == 200) {
          csvFile = response.responseText!;
        } else {
          throw Exception('Failed to load CSV file: ${response.status}');
        }
      }

      _data = const CsvToListConverter().convert<String>(
        csvFile,
        fieldDelimiter: ',',
        eol: '\n',
        convertEmptyTo: '',
        shouldParseNumbers: false,
      );
      return _data;
    } catch (e) {
      throw Exception(
        'Failed to load csv file: $e \n Remember to run the server',
      );
    }
  }

  // returns a csv from a list of lists of strings
  static String csvFromList(List<List<String>> list) {
    return const ListToCsvConverter().convert(
      list,
      fieldDelimiter: ',',
      eol: '\n',
    );
  }

  // returns the content of date_time.txt as a string
  static Future<String> getDateTime({bool test = false}) async {
    try {
      if (test) {
        return await getDate();
      } else {
        final response = await html.HttpRequest.request(
          'assets/date_time.txt',
          method: 'GET',
        );
        if (response.status == 200) {
          return response.responseText!;
        } else {
          throw Exception(
            'Failed to load TXT file: ${response.status}',
          );
        }
      }
    } catch (e) {
      throw Exception(
        'Failed to load txt file: $e \n Remember to run the server',
      );
    }
  }
}
