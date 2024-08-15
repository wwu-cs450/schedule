import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/csv_handler.dart';
import 'package:schedule_client/domain/data_handler.dart';

void main() {
  setUp(() {
    DataHandler.empty();
    CSVHandler.empty();
  });
  test('Data from CSV', () async {
    final List<List<String>> copyData = await DataHandler.fetchData(test: true);
    expect(identical(copyData, DataHandler.data), isTrue);
    expect(identical(copyData, CSVHandler.data), isTrue);
    expect(CSVHandler.data, isNotEmpty);
  });
}
