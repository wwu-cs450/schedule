import 'dart:convert';
import 'dart:io';

import 'package:server/ollama_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

Handler buildApiHandler() {
  final router = Router();
  final aiClient = AiChatClient();

  router.post('/api/transcript', (Request request) async {
    try {
      final body = await request.readAsString();
      // Validate it's proper JSON
      final json = jsonDecode(body);
      final file = File('test/data/sample_class_history.json');
      await file.writeAsString(
        const JsonEncoder.withIndent('    ').convert(json),
      );
      return Response.ok(
        jsonEncode({'status': 'saved'}),
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
  });

  router.post('/api/chat', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final messages =
          (json['messages'] as List)
              .map(
                (m) => {
                  'role': (m as Map<String, dynamic>)['role'] as String,
                  'content': m['content'] as String,
                },
              )
              .toList();

      final response = await aiClient.chat(messages);

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
  });

  // Add CORS middleware so the Flutter web client can reach the API.
  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  return handler;
}
