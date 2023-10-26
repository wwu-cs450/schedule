class Department {
  final String code;
  final String name;

  Department(this.code, this.name);

  static final _instances = <Department>{};

  static get instances {
    if (_instances.isEmpty) {
      Department._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    _instances
      ..add(Department('ACDM', 'Acadeum'))
      ..add(Department('BIOL', 'Biology'))
      ..add(Department('BUSI', 'Business'))
      ..add(Department('CHEM', 'Chemistry'))
      ..add(Department('COMM', 'Communication'))
      ..add(Department('MATH', 'Math'))
      ..add(Department('CPTR', 'Computer Science'));
    /*More entries can be added later as per assignment
        description.*/
  }
}
