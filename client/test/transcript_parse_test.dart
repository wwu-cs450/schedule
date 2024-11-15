import 'package:client/views/transcript_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TranscriptPage', () {
    test('correctly parses transcript text', () {
      const extractedText = '''
        CPTR 141 Fundamentals of Programming I 4 Fall, 2021 A
        MATH 181 Calculus I 4 Spring, 2022 D+
        RELB 106 Parables of Jesus 2 Fall, 2021 W
      ''';

      final courses = TranscriptPage.parseCourses(extractedText);

      expect(courses.length, 3);

      // Verify the properties of each parsed course
      final course1 = courses[0];
      expect(course1.subject, 'CPTR');
      expect(course1.classNumber, '141');
      expect(course1.course, 'Fundamentals of Programming I');
      expect(course1.credits, 4.0);
      expect(course1.term, 'Fall, 2021');
      expect(course1.status, 'Passed');

      final course2 = courses[1];
      expect(course2.subject, 'MATH');
      expect(course2.classNumber, '181');
      expect(course2.course, 'Calculus I');
      expect(course2.credits, 4.0);
      expect(course2.term, 'Spring, 2022');
      expect(course2.status, 'Failed');

      final course3 = courses[2];
      expect(course3.subject, 'RELB');
      expect(course3.classNumber, '106');
      expect(course3.course, 'Parables of Jesus');
      expect(course3.credits, 2.0);
      expect(course3.term, 'Fall, 2021');
      expect(course3.status, 'Withdrew');
    });
  });
}
