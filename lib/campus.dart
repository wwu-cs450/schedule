// ignore_for_file: type_annotate_public_apis

class Campus {
  Campus(this.code, this.name);
  final String code;
  final String name;

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
