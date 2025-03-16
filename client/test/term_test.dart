import 'package:client/domain/term.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    final term = Term(2239, 'Fall 2023');
    assert(term.code == 2239);
    assert(term.name == 'Fall 2023');
  });

  test('instances', () {
    final terms = Term.instances;
    assert(Term.allTerms().name == 'All Terms');
    assert(terms.length == 10);
    assert(terms.any((element) => element.code == 2239));
  });
  test('test cached Tests', () {
    final Term summerInstance = Term.findCachedTerm(2246);
    expect(summerInstance.code, Term(2246, 'Summer 2024').code);
    Object? ex;
    try {
      Term.findCachedTerm(1111);
    } catch (e) {
      ex = e;
    }
    expect(ex.runtimeType, StateError);
  });
}
