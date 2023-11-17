import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/term.dart';

void main() {
  test('constructor and accessors', () {
    final term = Term(2239, 'Fall 2023');
    assert(term.code == 2239);
    assert(term.name == 'Fall 2023');
  });

  test('instances', () {
    final terms = Term.instances;
    assert(Term.allTerms().name == 'ALL');
    assert(terms.length == 6);
    assert(
      terms.any(
        (element) => element.code == 2239,
      ),
    );
  });
}
