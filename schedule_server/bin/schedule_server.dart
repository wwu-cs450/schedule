import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:schedule_server/schedule.dart';

Future<void> dataStream() async {
  data = await getSchedule();
}

String data = '';

void main(List<String> args) async {
  data = await getSchedule();
  //Change path based on hostname
  final host = Platform.localHostname;
  final File file;
  if (host == 'schedule') {
    file = File('/var/www/html/class_data.csv');
  } else {
    file = File('../schedule_client/assets/class_data.csv');
  }

  // ignore: unused_local_variable
  var dataFile = await file.writeAsString(data);
  const fiveMin = Duration(minutes: 5);
  Timer.periodic(fiveMin, (timer) async {
    await dataStream();
    dataFile = await file.writeAsString(utf8.encode(data) as String);
  });
}
