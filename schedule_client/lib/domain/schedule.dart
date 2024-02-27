import 'package:http/http.dart' as http;
//Necessary library
import 'package:universal_html/html.dart' as html;

Future<String> getSchedule() async {
  late String host;
  host = '${html.window.location.protocol}//'
      '${html.window.location.hostname}:8080';

  final response = await http.get(
    Uri.parse(host),
  );
  return response.body;
}
