class Subject {
  final String code;
  final String name;

  Subject(this.code, this.name);

  static final instances = <Subject>{};

  static void initialize() {
    instances
      ..add(Subject('ACCT', 'Accounting'))
      ..add(Subject('CPTR', 'Computer Science'))
      ..add(Subject('MATH', 'Mathematics'))
      ..add(Subject('PHYS', 'Physics'));

    /*More entries can be added later as per assignment
      description.*/
  }
}
