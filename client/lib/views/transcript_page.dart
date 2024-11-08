import 'package:flutter/material.dart';

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({required this.extractedText, super.key});
  final String extractedText;

  List<Map<String, dynamic>> parseCourses(String transcriptText) {
    final coursePattern = RegExp(
      r'(?<subject>[A-Z]{3,4})\s+(?<number>\d+[A-Z]*)\s+(?<course>[\w\s/&,\-]+?)\s+(?<credits>\d+(\.\d+)?)\s+(?<term>[A-Za-z]+,\s\d{4})\s*(?:(?<grade>[A-D][+-]?|F|S|W|N/A|(?=\s)[^A-Za-z\s]+))?(?=\s+[A-Z]{2,4}\s+\d+|\s*$)',
      multiLine: true,
    );
    final courses = <Map<String, dynamic>>[];
    for (final match in coursePattern.allMatches(transcriptText)) {
      final subject = match.namedGroup('subject')?.trim();
      final number = match.namedGroup('number')?.trim();
      final course = match.namedGroup('course')?.trim();
      final credits = match.namedGroup('credits') != null
          ? double.tryParse(match.namedGroup('credits')!)
          : 0.0;
      final term = match.namedGroup('term')?.trim();
      final String grade = match.namedGroup('grade')?.trim() ??
          'N/A'; // Default to "N/A" if no grade

      if (subject != null && number != null && course != null && term != null) {
        courses.add({
          'subject': subject,
          'number': number,
          'course': course,
          'credits': credits,
          'term': term,
          'grade': grade,
        });
      }
    }
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    final courses = parseCourses(extractedText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcript Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: courses.isNotEmpty
            ? ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        '${course["subject"]} ${course["number"]}: ${course["course"]}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Credits: ${course["credits"]} | Term: ${course["term"]} | Grade: ${course["grade"]}',
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No courses found in transcript data.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
