import 'dart:convert';

import 'package:client/domain/host.dart';
import 'package:client/domain/persister.dart';
import 'package:http/http.dart' as http;

abstract class AiHandler {
  List<Map<String, String>> messageHistory = [];

  Future<String> sendMessage(String message) async {
    throw UnimplementedError();
  }
}

// class MockAiHandler extends AiHandler {
//   @override
//   Future<String> sendMessage(String message) async {
//     messageHistory.add({'role': 'user', 'content': message});

//     await Future.delayed(const Duration(seconds: 4));
//     final response = 'This is a mock response to: "$message"';

//     messageHistory.add({'role': 'assistant', 'content': response});
//     return response;
//   }
// }

class ServerAiHandler extends AiHandler {
  final _host = host();

  @override
  Future<String> sendMessage(String message) async {
    final courseHistory = await AbstractPersister.instance.readCourseHistory();
    
    print('Sending message to server: $message');
    messageHistory.add({'role': 'user', 'content': message});

    final uri = Uri.parse('$_host/api/chat');
    final body = jsonEncode({
      'messages': messageHistory,
      'courseHistory': courseHistory,
      });

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
