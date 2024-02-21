import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/data_handler.dart';
import 'package:schedule_client/domain/instructor.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });
  test('constructor and accessors', () {
    final instructor = Instructor('James Foster');
    assert(instructor.name == 'James Foster');
  });

  test('instances', () {
    final instructors = Instructor.instances;
    expect(instructors.length, 225);
    expect(
      instructors.any(
        (element) => element.name == 'James Foster',
      ),
      true,
    );
  });
  test(
      'instructorWithName for James Foster and the stateError for a notFound name',
      () {
    final fosterName = Instructor.instructorWithName('James Foster');
    expect(fosterName.name, 'James Foster');
    Object? ex;
    try {
      Instructor.instructorWithName('Fake Fakemen');
    } catch (e) {
      ex = e;
    }
    expect(ex.runtimeType, StateError);
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
