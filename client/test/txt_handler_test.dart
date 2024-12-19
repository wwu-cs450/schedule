import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fetch DateTime', () async {
    final String dateTime = await DataHandler.fetchDateTime(test: true);
    const String expectedDateTime = '2024-12-13 09:11:27.995005';

    expect(dateTime, expectedDateTime);
  });
}
