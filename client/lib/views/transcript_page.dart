import 'package:flutter/material.dart';

// Class model to represent course data
class Classes {
  Classes({
    required this.subject,
    required this.classNumber,
    required this.course,
    required this.credits,
    required this.term,
    required String grade,
  }) : status = _determineStatus(grade);

  final String subject;
  final String classNumber;
  final String course;
  final double credits;
  final String term;
  final String status;

  // Determine status based on grade
  static String _determineStatus(String grade) {
    if (grade == 'N/A') {
      return 'N/A';
    }
    if (grade == 'W') {
      return 'Withdrew';
    }
    if (grade == 'F' || grade == 'D-' || grade == 'D' || grade == 'D+') {
      return 'Failed';
    }
    return 'Passed';
  }

  @override
  String toString() {
    return 'Classes(subject: $subject, classNumber: $classNumber, course: $course, credits: $credits, term: $term, status: $status)';
  }
}

// TranscriptPage widget
class TranscriptPage extends StatelessWidget {
  const TranscriptPage({required this.extractedText, super.key});

  final String extractedText;

  // List of Class objects to store parsed courses
  List<Classes> get classes => parseCourses(extractedText);

  /// Parse courses from transcript text and return a list of Class objects
  static List<Classes> parseCourses(String transcriptText) {
    final coursePattern = RegExp(
      r'(?<subject>[A-Z]{3,4})\s+(?<number>\d+[A-Z]*)\s+(?<course>[\w\s/&,\-]+?)\s+(?<credits>\d+(\.\d+)?)\s+(?<term>[A-Za-z]+,\s\d{4})\s*(?:(?<grade>[A-D][+-]?|F|S|W|N/A|(?=\s)[^A-Za-z\s]+))?(?=\s+[A-Z]{2,4}\s+\d+|\s*$)',
      multiLine: true,
    );

    final parsedClasses = <Classes>[];

    for (final match in coursePattern.allMatches(transcriptText)) {
      final subject = match.namedGroup('subject')?.trim();
      final classNumber = match.namedGroup('number')?.trim();
      final course = match.namedGroup('course')?.trim();
      final credits = match.namedGroup('credits') != null
          ? double.tryParse(match.namedGroup('credits')!)
          : 0.0;
      final term = match.namedGroup('term')?.trim();
      final grade = match.namedGroup('grade')?.trim() ?? 'N/A';

      if (subject != null &&
          classNumber != null &&
          course != null &&
          term != null) {
        parsedClasses.add(
          Classes(
            subject: subject,
            classNumber: classNumber,
            course: course,
            credits: credits ?? 0.0,
            term: term,
            grade: grade,
          ),
        );
      }
    }
    return parsedClasses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcript Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: classes.isNotEmpty
            ? ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final course = classes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        '${course.subject} ${course.classNumber}: ${course.course}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Credits: ${course.credits} | Term: ${course.term} | Status: ${course.status}',
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
