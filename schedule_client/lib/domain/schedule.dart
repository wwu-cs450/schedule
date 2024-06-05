// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

Future<String> getSchedule() async {
  final request = await HttpRequest.getString('class_data.csv');
  return request;
}
