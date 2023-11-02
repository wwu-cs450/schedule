import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/instructor.dart';

void main() {
  test('constructor and accessors', () {
    final instructor = Instructor('James Foster');
    assert(instructor.name == 'James Foster');
  });

  test('instances', () {
    final instructors = Instructor.instances;
    assert(instructors.length == 4);
    assert(
      instructors.any(
        (element) => element.name == 'James Foster',
      ),
    );
  });
}
