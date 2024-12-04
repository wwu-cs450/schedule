// File: course_description_test.dart

import 'package:client/domain/course_description.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course Description Test', () {
    test('should return course description for CPTR 108', () {
      const text = '''
CPTR 108   The Art and Practice of Computer Science  An overview of computer science as a discipline and profession.
Students will understand the historical  development of computing and the role of computing in modern society, discuss social and ethical
issues in  computer science from a Christian world view, and appreciate the role of computer science professional  organizations. Students
will contribute to an open source project and will understand the importance of  portfolio building and internships in preparing to enter
the workforce.  Credits  3  Prerequisite  CPTR 141  Distribution  Computer Science
''';

      const expectedDescription =
          'An overview of computer science as a discipline and profession.\n'
          'Students will understand the historical  development of computing and the role of computing in modern society, discuss social and ethical\n'
          'issues in  computer science from a Christian world view, and appreciate the role of computer science professional  organizations. Students\n'
          'will contribute to an open source project and will understand the importance of  portfolio building and internships in preparing to enter\n'
          'the workforce.';

      expect(getCourseDescription(text), expectedDescription);
    });

    test('should return course description for CPTR 141', () {
      const text = '''
CPTR 141   Fundamentals of Programming I  Introduction to computer programming in-the-small using the Python language for
students with little or  no experience. Students will write, debug, and execute programs utilizing variables,    ow control  (sequencing,
selection, and repetition),    le I/O, lists, dictionaries, and functions.  Credits  4  Distribution  Computer Science
''';

      const expectedDescription =
          'Introduction to computer programming in-the-small using the Python language for\n'
          'students with little or  no experience. Students will write, debug, and execute programs utilizing variables,    ow control  (sequencing,\n'
          'selection, and repetition),    le I/O, lists, dictionaries, and functions.';

      expect(getCourseDescription(text), expectedDescription);
    });

    test('should return course description for CPTR 352', () {
      const text = '''
CPTR 352   Operating Systems  Rigorous introduction to the principles and practice of modern operating systems. Students
will be able to  explain the process and thread models used in modern operating systems, implement and utilize  synchronization
primitives, compare and contrast strategies for handling deadlock and resource  scheduling, explain modern memory organization and
management techniques, and describe the  structure of modern    le systems.  Credits  4  Prerequisite  CPTR 242 ,   CPTR 280
Distribution  Computer Science
''';

      const expectedDescription =
          'Rigorous introduction to the principles and practice of modern operating systems. Students\n'
          'will be able to  explain the process and thread models used in modern operating systems, implement and utilize  synchronization\n'
          'primitives, compare and contrast strategies for handling deadlock and resource  scheduling, explain modern memory organization and\n'
          'management techniques, and describe the  structure of modern    le systems.';

      expect(getCourseDescription(text), expectedDescription);
    });

    test('should return "No Description" for empty input', () {
      const text = '';
      const expectedDescription = 'No Description';

      expect(getCourseDescription(text), expectedDescription);
    });

    test('should return "No Description" for input with just metadata', () {
      const text = '''
CPTR 241   Data Structures and Algorithms  Credits  3  Prerequisite  CPTR 141  Distribution  Computer Science
''';

      const expectedDescription = '';

      expect(getCourseDescription(text), expectedDescription);
    });
  });
}
