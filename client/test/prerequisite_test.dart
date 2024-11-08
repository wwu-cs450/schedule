import 'package:client/domain/prerequisite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prerequisite Test', () {
    test('should return course prerequisite', () {
      const text = '''
CPTR 108 The Art and Practice of Computer Science
An overview of computer science as a discipline and profession. Students will understand the historical development of computing and the role of computing in modern society, discuss social and ethical issues in computer science from a Christian world view, and appreciate the role of computer science professional organizations. Students will contribute to an open source project and will understand the importance of portfolio building and internships in preparing to enter the workforce.
Credits
3
Prerequisite
CPTR 141
Distribution
Computer Science
''';

      const expectedPrerequisite = 'CPTR 141';

      expect(getCoursePrerequisite(text), expectedPrerequisite);
    });
  });
}
