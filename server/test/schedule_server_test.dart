import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  test('ClassOpen Reachable', () async {
    final Map<String, String> queryParams = <String, String>{
      'strm': 'f2024',
      'submit': 'Search',
    };
    final response = await http.get(
      Uri.https('classopen.wallawalla.edu', '/classopenps.php', queryParams),
    );
    expect(
      response.body.isNotEmpty,
      true,
      reason: 'Did not receive anything from ClassOpen',
    );
  });
}
