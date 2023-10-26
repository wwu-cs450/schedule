class Campus {
  final String code;
  final String name;

  Campus(this.code, this.name);

  static final _instances = <Campus>{};

  static get instances {
    if (_instances.isEmpty) {
      Campus._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    _instances
      ..add(Campus('ACA', 'Adventist Academies Abroad'))
      ..add(Campus('CP', 'College Place'))
      ..add(Campus('PD', 'Portland'));
  }
}
