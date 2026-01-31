import 'dart:io';

class AiTools {
  String getUserClassHistory() {
    final file = File('./test/data/sample_class_history.json');
    return file.readAsStringSync();
  }
}
