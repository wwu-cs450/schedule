import 'package:client/views/transcript_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TranscriptPage', () {
    test('correctly parses transcript text', () {
      const extractedText = '''
        CPTR 141 Fundamentals of Programming I 4 Fall, 2021 A
        MATH 181 Calculus I 4 Spring, 2022 B+
        MATH 106 Parables of Jesus 2 Fall, 2021 W
      ''';

      const transcriptPage = TranscriptPage(extractedText: extractedText);
      final courses = transcriptPage.parseCourses(extractedText);

      expect(courses.length, 3);

      expect(courses[0], {
        'subject': 'CPTR',
        'number': '141',
        'course': 'Fundamentals of Programming I',
        'credits': 4,
        'term': 'Fall, 2021',
        'grade': 'A',
      });

      expect(courses[1], {
        'subject': 'MATH',
        'number': '181',
        'course': 'Calculus I',
        'credits': 4,
        'term': 'Spring, 2022',
        'grade': 'B+',
      });

      expect(courses[2], {
        'subject': 'MATH',
        'number': '106',
        'course': 'Parables of Jesus',
        'credits': 2,
        'term': 'Fall, 2021',
        'grade': 'W',
      });
    });
  });
}
