import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:server/api.dart';
import 'package:server/bulletin.dart';
import 'package:server/html_handler.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addOption(
    'bulletin',
    callback: (String? value) async {
      if (value != null) {
        await bulletin(value);
        exit(0);
      }
    },
  );
  parser.addOption('port', abbr: 'p', defaultsTo: '8080');
  parser.parse(arguments);

  final port = int.parse(parser.parse(arguments)['port'] as String);

  // ── Start the HTTP API server ──────────────────────────────────────────
  final handler = buildApiHandler();
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  print('API server running on http://${server.address.host}:${server.port}');

  // ── Start the class-data scraper loop ──────────────────────────────────
  unawaited(_scrapeLoop());
}

/// Periodically fetches class data from classopen.wallawalla.edu and writes
/// it to a CSV file every 5 minutes.
Future<void> _scrapeLoop() async {
  final File dataFile;
  final File dateTimeFile;

  if (Platform.localHostname == 'schedule-vm') {
    dataFile = File('/var/www/html/assets/class_data.csv');
    dateTimeFile = File('/var/www/html/assets/date_time.txt');
  } else {
    dataFile = File('../client/assets/class_data.csv');
    dateTimeFile = File('../client/assets/date_time.txt');
  }

  bool firstTime = true;
  while (true) {
    try {
      final List<List<String>> data = await HTMLHandler().listFromHtml();
      final csv = ListToCsvConverter().convert(data);
      await dataFile.writeAsString(csv);
      final timestamp = DateTime.now().toString().substring(0, 16);
      await dateTimeFile.writeAsString(timestamp);
      if (firstTime) {
        firstTime = false;
        print('Initial class data download is complete.');
      }
    } catch (e) {
      print('Error scraping class data: $e');
    }
    await Future.delayed(Duration(minutes: 5));
  }
}
