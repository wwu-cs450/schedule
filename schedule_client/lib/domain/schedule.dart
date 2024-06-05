// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart';

Future<String> getSchedule() async {
  final String request;
  if (kDebugMode) {
    request = await HttpRequest.getString('assets/class_data.csv');
  } else {
    request = await HttpRequest.getString('class_data.csv');
  }
  return request;
}
