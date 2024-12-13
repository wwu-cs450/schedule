import 'dart:async';
import 'dart:io';
import 'package:server/schedule.dart';

Future<void> dataStream() async {
  data = await getSchedule();
}

String data = '';

void main() async {
  data = await getSchedule();
  // Change path based on hostname
  final host = Platform.localHostname;
  final File dataFile;
  final File dateTimeFile;
  if (host == 'schedule-vm') {
    dataFile = File('/var/www/html/assets/class_data.csv');
    dateTimeFile = File('/var/www/html/assets/date_time.txt');
  } else {
    dataFile = File('../client/assets/class_data.csv');
    dateTimeFile = File('../client/assets/date_time.txt');
  }

  // Write data to class_data.csv
  await dataFile.writeAsString(data);

  // Write current date and time to date_time.txt
  final currentDateTime = DateTime.now().toString();
  await dateTimeFile.writeAsString(currentDateTime);

  const fiveMin = Duration(minutes: 5);
  Timer.periodic(fiveMin, (timer) async {
    await dataStream();
    await dataFile.writeAsString(data);
    final currentDateTime = DateTime.now().toString();
    await dateTimeFile.writeAsString(currentDateTime);
  });
}
