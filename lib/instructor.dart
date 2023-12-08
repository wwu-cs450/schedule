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

  static Instructor instructorWithName(String name) {
    final instructorFound =
        Instructor.instances.firstWhere((instance) => instance.name == name);

    return instructorFound;
  }

  static void _initialize() {
    final classopenCSV = getListFromCsv();
    // Remove headers
    classopenCSV.removeAt(0);
    for (final value in classopenCSV) {
      final List<String> instructorStrings = value[23].split(', '); // col 23
      for (final instructorString in instructorStrings) {
        if (instructorString.trim().isNotEmpty &&
            !_instances
                .any((instructor) => instructor.name == instructorString)) {
          _instances.add(Instructor(instructorString));
        }
      }
    }
  }

  @override
  String toString() => name;
}
