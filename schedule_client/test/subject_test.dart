import 'package:flutter_test/flutter_test.dart';

import 'package:schedule_client/domain/subject.dart';

void main() {
  test('constructor and accessors', () {
    final subject = Subject('CPTR', 'Computer Science');
    assert(subject.code == 'CPTR');
    assert(subject.name == 'Computer Science');
  });

  test('instances', () {
    final subjects = Subject.instances;
    assert(Subject.allSubjects().name == 'All Subjects');
    assert(subjects.length == 101);
    assert(
      subjects.any(
        (element) => element.code == 'CPTR',
      ),
    );
  });
}
