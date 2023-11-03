import 'package:schedule/load_csv.dart';

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
    final classopenCSV = getListFromCsv();
    // Remove headers
    classopenCSV.removeAt(0);
    for (final value in classopenCSV) {
      if (!_instances.any((instructor) => instructor.name == value[23])) {
        // ignore: todo
        //TODO split multiple instructors into multiple different, instead of one.
        _instances.add(Instructor(value[23]));
      }
    }
  }
}
