import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  final port = '8081';
  //final host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/schedule_server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());
  test('data return', () async {
    late String host;
    final reason = 'Did not receive a 200 code';
    final reason2 = 'Body is empty';
    host = '${html.window.location.protocol}//'
        '${html.window.location.hostname}:8081';

    final response = await http.get(
      Uri.parse(host),
    );
    expect(response.statusCode, 200, reason: reason);
    expect(response.body.isNotEmpty, true, reason: reason2);
  });
}
