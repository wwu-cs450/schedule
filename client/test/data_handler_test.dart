import 'package:client/domain/csv_handler.dart';
import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    DataHandler.empty();
    CSVHandler.empty();
  });
  test('Data from CSV', () async {
    await DataHandler.fetchData(test: true);
    final List<List<String>> copyData = DataHandler.data;
    expect(identical(copyData, DataHandler.data), isTrue);
    expect(identical(copyData, CSVHandler.data), isTrue);
    expect(CSVHandler.data, isNotEmpty);
  });
}
