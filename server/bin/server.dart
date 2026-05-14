import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:server/bulletin.dart';
import 'package:server/html_handler.dart';

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

  parser.parse(arguments);

  final File dataFile;
  final File dateTimeFile;

  // Change path based on hostname
  if (Platform.environment['ENVIRONMENT'] == 'production' ||
      Platform.environment['ENVIRONMENT'] == 'staging') {
    dataFile = File('/usr/share/nginx/html/assets/class_data.csv');
    dateTimeFile = File('/usr/share/nginx/html/assets/date_time.txt');
  } else {
    dataFile = File('../client/assets/class_data.csv');
    dateTimeFile = File('../client/assets/date_time.txt');
  }

  var firstTime = true;

  while (true) {
    final List<List<String>> data = await HTMLHandler().listFromHtml();
    final csv = ListToCsvConverter().convert(data);

    await dataFile.writeAsString(csv);

    final timestamp = DateTime.now().toString().substring(0, 16);
    await dateTimeFile.writeAsString(timestamp);

    if (firstTime) {
      firstTime = false;
      print('Initial download is complete.');
    }

    await Future.delayed(Duration(minutes: 5));
  }
}
