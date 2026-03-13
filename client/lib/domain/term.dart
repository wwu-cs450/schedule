import 'package:client/domain/class.dart';

class Term implements Comparable {
  Term(this.code, this.name);
  final int code;
  final String name;

  static var _instances = <Term>[];
  static int defaultTermIndex = 0;

  static Term defaultTerm() {
    return instances.elementAt(defaultTermIndex);
  }

  @override
  int compareTo(dynamic other) {
    return code.compareTo(other.code);
  }

  static Term findCachedTerm(int code) {
    final foundTerm = Term.instances.firstWhere(
      (instance) => instance.code == code,
    );
    return foundTerm;
  }

  static Term? fromCode(int code) {
    try {
      return _instances.firstWhere((term) => term.code == code);
    } catch (e) {
      return null;
    }
  }

  bool includesClass(Class classInstance) {
    return classInstance.term == this;
  }

  //These will need to change with time
  static void _initialize() {
    _instances = [
      Year(2027),
      Year(2026),
      Year(2025),
      Year(2024),
      Term(2236, 'Summer 2023'),
      Term(2239, 'Fall 2023'),
      Term(2241, 'Winter 2024'),
      Term(2243, 'Spring 2024'),
      Term(2246, 'Summer 2024'),
      Term(2249, 'Fall 2024'),
      Term(2251, 'Winter 2025'),
      Term(2253, 'Spring 2025'),
      Term(2256, 'Summer 2025'),
      Term(2259, 'Fall 2025'),
      Term(2261, 'Winter 2026'),
      Term(2263, 'Spring 2026'),
      Term(2266, 'Summer 2026'),
      Term(2269, 'Fall 2026'),
      Term(2271, 'Winter 2027'),
      Term(2273, 'Spring 2027'),
      Term(2276, 'Summer 2027'),
    ];
  }

  static List<Term> get instances {
    if (_instances.isEmpty) {
      _initialize();
    }
    return _instances;
  }

  int startYear() {
    final int year = code % 1000 ~/ 10 + 2000;
    return code % 10 < 9 ? year - 1 : year;
  }

  @override
  String toString() {
    return name;
  }
}

class Year extends Term {
  Year(int year) : super(year, '${year - 1}-$year');

  @override
  bool includesClass(Class classInstance) {
    final int startTerm = int.parse('2${(code - 1) % 100}6');
    final int endTerm = int.parse('2${code % 100}6');
    return classInstance.term.code >= startTerm &&
        classInstance.term.code <= endTerm;
  }

  @override
  int startYear() => code - 1;
}
