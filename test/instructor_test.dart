import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/instructor.dart';

void main() {
  test('constructor and accessors', () {
    final instructor = Instructor('James Foster');
    assert(instructor.name == 'James Foster');
  });

  test('instances', () {
    final instructors = Instructor.instances;
    expect(instructors.length, 237);
    expect(
      instructors.any(
        (element) => element.name == 'James Foster',
      ),
      true,
    );
  });

  test('double instructors', () {
    expect(
      Instructor.instances.any((e) => e.name == 'Deisy Haid, Anali Pesqueira'),
      isFalse,
    ); //this double instructor used to exist before splitting
    expect(Instructor.instances.any((e) => e.name == 'Deisy Haid'), isTrue);
    expect(
      Instructor.instances.any((e) => e.name == 'Anali Pesqueira'),
      isTrue,
    );
  });
}
