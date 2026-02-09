import 'dart:convert';

import 'package:http/http.dart' as http;

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

class ServerAiHandler extends AiHandler {
  ServerAiHandler({this.baseUrl = 'http://localhost:8080'});

  final String baseUrl;

  @override
  Future<String> sendMessage(String message) async {
    messageHistory.add({'role': 'user', 'content': message});

    final uri = Uri.parse('$baseUrl/api/chat');
    final body = jsonEncode({'messages': messageHistory});

    final httpResponse = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (httpResponse.statusCode != 200) {
      final error = 'Server error: ${httpResponse.statusCode}';
      messageHistory.add({'role': 'assistant', 'content': error});
      return error;
    }

    final json = jsonDecode(httpResponse.body) as Map<String, dynamic>;
    final response = json['response'] as String;

    messageHistory.add({'role': 'assistant', 'content': response});
    return response;
  }
}
