import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/get_html.dart';
import 'package:schedule/sample_html.dart';

void main() async {
  var html = await fetchHtml();
  var sample_html = fetchTestHtml();

  test('Both methods return String Type', () {
    assert(html.runtimeType == String);
    assert(sample_html.runtimeType == String);
  });
  test('The live HTML returns a string size within expected bounds', () {
    var error = 0.3;
    assert(html.length <= sample_html.length * (1.0 + error));
    assert(html.length >= sample_html.length * (1.0 - error));
  });
  test('Live HTML string has HTML in it', () {
    assert(html.contains('BIOL'));
    assert(html.contains('</div>'));
  });
}
