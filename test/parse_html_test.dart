import 'package:schedule/parse_html.dart';
import 'package:schedule/sample_html.dart';
import 'package:universal_html/parsing.dart';

import 'package:flutter_test/flutter_test.dart';

void main() async {
  final document = fetchTestHtml();
  final htmlDoc = parseHtmlDocument(document);
  final classTable = htmlDoc.getElementById('resulttable');
  final evenRows = classTable!.getElementsByClassName('evenrow');
  final testCase = evenRows[7].childNodes;

  test('Does addSection and addCourse Work without any exceptions?', () {
    try {
      addCourse(testCase);
    } catch (e) {
      assert(false);
    }
  });

  test('Does the html skimming work?', () {
    try {
      loadHtmlIn();
    } catch (e) {
      assert(false);
    }
  });
}
