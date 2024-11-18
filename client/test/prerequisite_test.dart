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

    test('should return "No Prerequisites" if no prerequisite is found', () {
      const text = '''
CPTR 141 Fundamentals of Programming I
Introduction to computer programming in-the-small using the Python language for students with little or no experience. Students will write, debug, and execute programs utilizing variables, flow control (sequencing, selection, and repetition), file I/O, lists, dictionaries, and functions.
Credits
4
Distribution
Computer Science
''';

      const expectedPrerequisite = 'No Prerequisites';

      expect(getCoursePrerequisite(text), expectedPrerequisite);
    });

    test('should return multiple prerequisites', () {
      const text = '''
CPTR 352 Operating Systems
Rigorous introduction to the principles and practice of modern operating systems. Students will be able to explain the process and thread models used in modern operating systems, implement and utilize synchronization primitives, compare and contrast strategies for handling deadlock and resource scheduling, explain modern memory organization and management techniques, and describe the structure of modern file systems. 
Credits
4
Prerequisite
CPTR 242, CPTR 280
Distribution
Computer Science
''';

      const expectedPrerequisite = 'CPTR 242, CPTR 280';

      expect(getCoursePrerequisite(text), expectedPrerequisite);
    });
  });
}
