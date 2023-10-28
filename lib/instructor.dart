class Instructor {
  final String name;

  Instructor(this.name);

  static final _instances = <Instructor>{};

  static get instances {
    if (_instances.isEmpty) {
      Instructor._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    _instances
      ..add(Instructor('James Foster'))
      ..add(Instructor('John Foster'))
      ..add(Instructor('Qin Ma'))
      ..add(Instructor('Rob Frohne'));
  }
}
