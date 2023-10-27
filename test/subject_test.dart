import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/subject.dart';

void main() {
  test('constructor and accessors', () {
    var subject = Subject('CPTR', 'Computer Science');
    assert(subject.code == 'CPTR');
    assert(subject.name == 'Computer Science');
  });

  test('instances', () {
    var subjects = Subject.instances;
    assert(subjects.length == 95);
    assert(subjects.any(
      (element) => element.code == 'CPTR',
    ));
  });
}
