import 'package:schedule_server/get_html.dart';
import 'package:test/test.dart';

void main() {
  test('ClassOpen Reachable', () async {
    final String response = await getHtml();
    expect(
      response.isNotEmpty,
      true,
      reason: 'Did not receive anything from ClassOpen',
    );
  });
}
