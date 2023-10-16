import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/term.dart';

void main() {
  test('constructor and accessors', () {
    var term = Term(2239, 'Fall 2023');
    assert(term.code == 2239);
    assert(term.name == 'Fall 2023');
  });
}
