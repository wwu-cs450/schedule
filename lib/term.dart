class Term {
  Term(this.code, this.name);
  final int code;
  final String name;

  static final _instances = <Term>{};

  static Set<Term> get instances {
    if (_instances.isEmpty) {
      Term._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    _instances
      ..add(Term(2239, 'Fall 2023'))
      ..add(Term(2241, 'Winter 2024'))
      ..add(Term(2243, 'Spring 2024'))
      ..add(Term(2246, 'Summer 2024'))
      ..add(Term(2249, 'Fall 2024'));
  }
}
