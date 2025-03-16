import 'package:client/domain/subject.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor and accessors', () {
    final subject = Subject('CPTR', 'Computer Science');
    expect(subject.code, 'CPTR');
    expect(subject.name, 'Computer Science');
  });

  test('instances', () {
    final subjects = Subject.instances;
    expect(Subject.allSubjects().name, 'All Subjects');
    expect(subjects.length, 103);
    expect(subjects.any((element) => element.code == 'CPTR'), true);
  });
}
