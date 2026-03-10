import 'package:client/domain/term.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Term.defaultTermIndex = 1; // 2024-2025
  test('constructor and accessors', () {
    final term = Term(2239, 'Fall 2023');
    expect(term.code, 2239);
    expect(term.name, 'Fall 2023');
  });

  test('instances', () {
    final terms = Term.instances;
    expect(Term.defaultTerm().name, '2024-2025');
    expect(terms.length, 20);
    expect(terms.any((element) => element.code == 2239), true);
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
