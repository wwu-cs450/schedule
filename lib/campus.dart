class Campus {
  final String code;
  final String name;

  Campus(this.code, this.name);

  static final instances = <Campus>{};

  static void initialize() {
    instances
      ..add(Campus('ACA', 'Adventist Academies Abroad'))
      ..add(Campus('CP', 'College Place'))
      ..add(Campus('PD', 'Portland'));
  }
}
