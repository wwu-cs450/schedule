class Department {
  final String code;
  final String name;

  Department(this.code, this.name);

  static final instances = <Department>{};

  static void initialize() {
    instances
      ..add(Department('ACDM', 'Acadeum'))
      ..add(Department('BIOL', 'Biology'))
      ..add(Department('BUSI', 'Business'))
      ..add(Department('CHEM', 'Chemistry'))
      ..add(Department('COMM', 'Communication'))
      ..add(Department('CPTR', 'Computer Science'));
    /*More entries can be added later as per assignment
      description.*/
  }
}
