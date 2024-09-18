import 'package:csv/csv.dart';
import 'package:server/html_handler.dart';

Future<String> getSchedule() async {
  final List<List<String>> data = await HTMLHandler.listFromHtml();
  final csv = ListToCsvConverter().convert(data);
  return csv;
}
