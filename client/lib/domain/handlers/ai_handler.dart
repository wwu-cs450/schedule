abstract class AiHandler {
  List<Map<String, String>> messageHistory = [];

  Future<String> sendMessage(String message) async {
    throw UnimplementedError();
  }
}

class MockAiHandler extends AiHandler {
  @override
  Future<String> sendMessage(String message) async {
    messageHistory.add({'role': 'user', 'content': message});

    await Future.delayed(const Duration(seconds: 4));
    final response = 'This is a mock response to: "$message"';

    messageHistory.add({'role': 'assistant', 'content': response});
    return response;
  }
}
