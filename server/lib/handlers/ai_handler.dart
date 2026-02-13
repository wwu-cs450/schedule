import 'dart:convert';
import 'dart:io';

import 'package:server/ollama_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AiHandler {
  Future<Response> handleChat(Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final messages = (json['messages'] as List)
          .map(
            (m) => {
              'role': (m as Map<String, dynamic>)['role'] as String,
              'content': m['content'] as String,
            },
          )
          .toList();

      final response = await AiChatClient().chat(messages);

      return Response.ok(
        jsonEncode({'response': response}),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException {
      return Response(
        HttpStatus.badRequest,
        body: jsonEncode({'error': 'Invalid JSON in request body'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // Future<Response> uploadTranscript(Request request) async {
  //   try {
  //     final body = await request.readAsString();
  //     // Validate it's proper JSON
  //     final json = jsonDecode(body);
  //     final file = File('test/data/sample_class_history.json');
  //     await file.writeAsString(
  //       const JsonEncoder.withIndent('    ').convert(json),
  //     );
  //     return Response.ok(
  //       jsonEncode({'status': 'saved'}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //   } on FormatException {
  //     return Response(
  //       HttpStatus.badRequest,
  //       body: jsonEncode({'error': 'Invalid JSON in request body'}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //   } catch (e) {
  //     return Response.internalServerError(
  //       body: jsonEncode({'error': e.toString()}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //   }
  // }

  Handler get handler {
    final router = Router();
    router.post('/api/chat', handleChat);
    // router.post('/api/upload-transcript', uploadTranscript);
    return router.call;
  }
}
