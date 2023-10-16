class Term {
  final int code;
  final String name;

  Term(this.code, this.name);

  static final instances = <Term>{};

  static void initialize() {
    instances
      ..add(Term(2239, 'Fall 2023'))
      ..add(Term(2241, 'Winter 2024'))
      ..add(Term(2243, 'Spring 2024'));
  }
}
