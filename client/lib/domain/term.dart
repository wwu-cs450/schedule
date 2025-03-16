import 'package:client/domain/class.dart';

class Term implements Comparable {
  Term(this.code, this.name);
  final int code;
  final String name;

  static var _instances = <Term>{};

  static Term allTerms() {
    return instances.first;
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

  static Term fromCode(int code) {
    return instances.firstWhere((term) => term.code == code);
  }

  bool includesClass(Class classInstance) {
    return classInstance.term == this;
  }

  //These will need to change with time
  static Set<Term> _initialize() {
    final Set<Term> instances = {};
    instances
      ..add(Term(2236, 'Summer 2023'))
      ..add(Term(2239, 'Fall 2023'))
      ..add(Term(2241, 'Winter 2024'))
      ..add(Term(2243, 'Spring 2024'))
      ..add(Term(2246, 'Summer 2024'))
      ..add(Term(2249, 'Fall 2024'))
      ..add(Term(2251, 'Winter 2025'))
      ..add(Term(2253, 'Spring 2025'))
      ..add(Term(2256, 'Summer 2025'));
    return instances;
  }

  static Set<Term> get instances {
    if (_instances.isEmpty) {
      _instances = {AllTerms(), ..._initialize()};
    }
    return _instances;
  }

  @override
  String toString() {
    return name;
  }
}

class AllTerms extends Term {
  AllTerms() : super(0, 'All Terms');

  @override
  bool includesClass(Class classInstance) {
    return true;
  }
}
