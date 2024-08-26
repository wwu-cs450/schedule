import 'package:flutter_test/flutter_test.dart';

import 'package:schedule_client/domain/subject.dart';

void main() {
  test('constructor and accessors', () {
    final subject = Subject('CPTR', 'Computer Science');
    expect(subject.code, 'CPTR');
    expect(subject.name, 'Computer Science');
  });

  test('instances', () {
    final subjects = Subject.instances;
    expect(Subject.allSubjects().name, 'All Subjects');
    expect(subjects.length, 102);
    expect(
      subjects.any((element) => element.code == 'CPTR'),
      true,
    );
  });
}
