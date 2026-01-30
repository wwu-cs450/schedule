import 'package:client/domain/class_storage.dart';
import 'package:client/domain/completed_classes.dart';
import 'package:flutter/material.dart';

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({required this.extractedText, super.key});

  final String extractedText;

  List<CompletedClass> get classes => parseCourses(extractedText);

  static List<CompletedClass> parseCourses(String transcriptText) {
    final coursePattern = RegExp(
      r'(?<subject>[A-Z]{3,4})\s+(?<number>\d+[A-Z]*)\s+(?<course>[\w\s/&,\-]+?)\s+(?<credits>\d+(\.\d+)?)\s+(?<term>[A-Za-z]+,\s\d{4})\s*(?:(?<grade>[A-D][+-]?|F|S|W|N/A|(?=\s)[^A-Za-z\s]+))?(?=\s+[A-Z]{2,4}\s+\d+|\s*$)',
      multiLine: true,
    );

    final parsedClasses = <CompletedClass>[];

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
          CompletedClass(
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

    // Save parsed classes globally
    ClassStorage().addClasses(parsedClasses);

    return parsedClasses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transcript Page')),
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
