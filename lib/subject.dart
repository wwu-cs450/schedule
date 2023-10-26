class Subject {
  final String code;
  final String name;

  Subject(this.code, this.name);

  static final _instances = <Subject>{};

  static get instances {
    if (_instances.isEmpty) {
      Subject._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    _instances
      ..add(Subject('ACCT', 'Accounting'))
      ..add(Subject('CPTR', 'Computer Science'))
      ..add(Subject('MATH', 'Mathematics'))
      ..add(Subject('PHYS', 'Physics'));

    /*More entries can be added later as per assignment
      description.*/
  }
}
