import 'package:client/views/transcript_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TranscriptPage', () {
    test('correctly parses transcript text', () {
      const extractedText = '''
        CPTR 141 Fundamentals of Programming I 4 Fall, 2021 A
        MATH 181 Calculus I 4 Spring, 2022 F
        RELB 106 Parables of Jesus 2 Fall, 2021 W
      ''';

      final courses = TranscriptPage.parseCourses(extractedText);

      expect(courses.length, 3);

      // Check first course
      expect(courses[0].subject, 'CPTR');
      expect(courses[0].classNumber, '141');
      expect(courses[0].course, 'Fundamentals of Programming I');
      expect(courses[0].credits, 4);
      expect(courses[0].term, 'Fall, 2021');
      expect(courses[0].status, 'Passed');

      // Check second course
      expect(courses[1].subject, 'MATH');
      expect(courses[1].classNumber, '181');
      expect(courses[1].course, 'Calculus I');
      expect(courses[1].credits, 4);
      expect(courses[1].term, 'Spring, 2022');
      expect(courses[1].status, 'Failed');

      // Check third course
      expect(courses[2].subject, 'RELB');
      expect(courses[2].classNumber, '106');
      expect(courses[2].course, 'Parables of Jesus');
      expect(courses[2].credits, 2);
      expect(courses[2].term, 'Fall, 2021');
      expect(courses[2].status, 'Withdrew');
    });
  });
}
