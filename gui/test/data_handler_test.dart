import 'package:flutter_test/flutter_test.dart';
import 'package:gui/csv_handler.dart';
import 'package:gui/data_handler.dart';
import 'package:gui/html_handler.dart';

void main() {
  setUp(() {
    DataHandler.empty();
    HTMLHandler.empty();
    CSVHandler.empty();
  });
  test('Data from CSV', () async {
    final List<List<String>> copyData =
        await DataHandler.fetchData(useCsv: true, test: true);
    expect(DataHandler.usingCsv, isTrue);
    expect(identical(copyData, DataHandler.data), isTrue);
    expect(identical(copyData, CSVHandler.data), isTrue);
    expect(identical(copyData, HTMLHandler.data), isFalse);
    expect(HTMLHandler.data, isEmpty);
    expect(CSVHandler.data, isNotEmpty);
  });
  test('Data from HTML', () async {
    final List<List<String>> copyData =
        await DataHandler.fetchData(useCsv: false, test: true);
    expect(DataHandler.usingCsv, isFalse);
    expect(identical(copyData, DataHandler.data), isTrue);
    expect(identical(copyData, CSVHandler.data), isFalse);
    expect(identical(copyData, HTMLHandler.data), isTrue);
    expect(HTMLHandler.data, isNotEmpty);
    expect(CSVHandler.data, isEmpty);
  });
  test('Fetching from both', () async {
    await DataHandler.fetchData(useCsv: true, test: true);
    final List<List<String>> copyData =
        await DataHandler.fetchData(useCsv: false, test: true);
    expect(DataHandler.usingCsv, isFalse);
    expect(identical(copyData, DataHandler.data), isTrue);
    expect(identical(copyData, CSVHandler.data), isFalse);
    expect(identical(copyData, HTMLHandler.data), isTrue);
    expect(HTMLHandler.data, isNotEmpty);
    expect(CSVHandler.data, isNotEmpty);
  });
}
