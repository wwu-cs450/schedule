import 'package:flutter/foundation.dart';
import 'package:schedule_client/domain/sample_csv.dart';
import 'package:universal_html/html.dart' as html;

Future<String> getSchedule() async {
  final String request;
  if (kDebugMode) {
    return getSample();
  } else {
    if (html.window.location.hostname == 'schedule') {
      request = await html.HttpRequest.getString('class_data.csv');
    } else {
      request = await html.HttpRequest.getString('assets/class_data.csv');
    }
    return request;
  }
}
