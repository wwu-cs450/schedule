import 'dart:io';

import 'package:ollama_dart/ollama_dart.dart';

class AiTools {
  static String getUserClassHistory() {
    final file = File(
      '/Users/anna/Documents/Programming/WWU/schedule/ai_server/test/data/sample_class_history.json',
    );
    return file.readAsStringSync();
  }

  static String getUserRegisteredClasses() {
    final file = File(
      '/Users/anna/Documents/Programming/WWU/schedule/ai_server/test/data/sample_registered_classes.json',
    );
    return file.readAsStringSync();
  }
}

final availableFunctions = {
  'getUserClassHistory': AiTools.getUserClassHistory,
  'getUserRegisteredClasses': AiTools.getUserRegisteredClasses,
};

final List<Tool> tools = [
  Tool(
    function: ToolFunction(
      name: 'getUserClassHistory',
      description: 'Get the user\'s past class history as JSON file.',
      parameters: {'type': 'object', 'properties': {}, 'required': []},
    ),
  ),
  Tool(
    function: ToolFunction(
      name: 'getUserRegisteredClasses',
      description:
          'Get the classes the user is registered for in this quarter and future quarters.',
      parameters: {'type': 'object', 'properties': {}, 'required': []},
    ),
  ),
];
