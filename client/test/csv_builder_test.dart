import 'package:client/domain/class.dart';
import 'package:client/domain/csv_builder.dart';
import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });
  test('Can convert and reconstruct list of classes', () {
    int i = 0;
    for (final element in Class.instances) {
      if (i < 10) {
        element.saved = true;
        i++;
      }
    }

    final String testCSV = createCSV();
    for (final element in Class.instances) {
      if (i < 10) {
        element.saved = false;
        i++;
      }
    }
    reloadSavedClasses(testCSV);
    expect(Class.instances.first.saved, true);
  });
}
