import 'package:schedule/class.dart';

class Term {
  Term(this.code, this.name);
  final int code;
  final String name;

  static var _instances = <Term>{};

  static Set<Term> get instances {
    if (_instances.isEmpty) {
      _instances = {AllTerms(), ..._initialize()};
    }
    return _instances;
  }

  static Set<Term> _initialize() {
    final Set<Term> instances = {};
    instances
      ..add(Term(2239, 'Fall 2023'))
      ..add(Term(2241, 'Winter 2024'))
      ..add(Term(2243, 'Spring 2024'))
      ..add(Term(2246, 'Summer 2024'))
      ..add(Term(2249, 'Fall 2024'));
    return instances;
  }

  bool includesClass(Class classInstance) {
    return classInstance.term == this;
  }

  static Term allTerms() {
    return instances.first;
  }
}

class AllTerms extends Term {
  AllTerms() : super(0, 'ALL');

  @override
  bool includesClass(Class classInstance) {
    return true;
  }
}
