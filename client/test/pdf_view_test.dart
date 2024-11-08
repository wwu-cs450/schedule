import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import 'feature_test_functions.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  testWidgets('Pdf Page', (WidgetTester tester) async {
    await pdfUploadPageTest(tester, 2370);
  });
}
