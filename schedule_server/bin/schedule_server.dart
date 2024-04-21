import 'dart:io';
import 'package:schedule_server/schedule.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

String data = '';
// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

Future<Response> _rootHandler(Request req) async {
  return Response.ok(data);
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(
        corsHeaders(headers: {'Access-Control-Allow-Headers': '*'}),
      )
      .addHandler(_router.call);
  data = await getSchedule();
  // For running in containers, we respect the PORT environment variable.
  final port = 8080;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
  //while (true) {}
}
