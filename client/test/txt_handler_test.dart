import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fetch DateTime', () async {
    await DataHandler.fetchData(test: true);
    final String dateTime = DataHandler.dateTime;
    const String expectedDateTime = '2024-12-13 09:11';

    expect(dateTime, expectedDateTime);
  });
}
