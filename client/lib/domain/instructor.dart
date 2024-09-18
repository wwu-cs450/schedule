import 'package:client/domain/data_handler.dart';

class Instructor implements Comparable {
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
    final classData = DataHandler.data;
    for (final value in classData) {
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
  int compareTo(dynamic other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() => name;
}
