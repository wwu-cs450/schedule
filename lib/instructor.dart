class Instructor {
  Instructor(this.name);
  final String name;

  static final _instances = <Instructor>{};

  static Set<Instructor> get instances {
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
