import 'dart:convert';
import 'dart:typed_data';

import 'package:common/completed_course.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfHelper {
  static Future<Uint8List> selectPdf() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Ensure bytes are available
    );

    if (result != null && result.files.single.bytes != null) {
      return result.files.single.bytes!;
    } else {
      throw 'No PDF file selected';
    }
  }

  static Future<String> extractTextFromPDF(Uint8List arrayBuffer) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: arrayBuffer);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final String extractedText = extractor.extractText();

      document.dispose();

      return extractedText;
    } catch (e) {
      throw 'Failed to extract text from PDF: $e';
    }
  }

  static List<CompletedCourse> parseTranscriptPdfText(String pdfText) {
    final List<CompletedCourse> classes = [];

    final termSections = splitTextIntoTerms(pdfText);

    for (final entry in termSections.entries) {
      final extractedCourses = extractCoursesFromTerm(entry.value, entry.key);
      classes.addAll(extractedCourses);
    }

    return classes;
  }

  static Map<String, String> splitTextIntoTerms(String pdfText) {
    final termPattern = RegExp(r'\b(Fall|Winter|Spring),\s*\d{4}\b');
    final terms = termPattern.allMatches(pdfText);
    final sections = pdfText.split(termPattern);

    final Map<String, String> termSections = {};

    for (int i = 1; i < sections.length; i += 1) {
      termSections[terms.elementAt(i - 1).group(0)!] = sections[i].trim();
    }

    return termSections;
  }

  static List<CompletedCourse> extractCoursesFromTerm(
    String text,
    String term,
  ) {
    final List<CompletedCourse> courses = [];

    final pattern = RegExp(
      r'([A-Z]{3,4}\s\d{2,3})' // course code
      r'([\s\S]+?)' // course title (lazy match)
      r'(A[+-]?|B[+-]?|C[+-]?|D[+-]?|F[+-]?|S|NC|I\*?|IP\*?|W|X|Z|AU|NR)' // grade
      r'(\d+\.\d)', // credits
    );

    final matches = pattern.allMatches(text);

    for (final m in matches) {
      final course = m.group(1)!.trim().replaceAll('\n', ' ');
      final title = m.group(2)!.trim().replaceAll('\n', ' ');
      final grade = m.group(3)!.trim().replaceAll('\n', ' ');
      final credits = m.group(4)!.trim().replaceAll('\n', ' ');

      courses.add(
        CompletedCourse(
          course: course,
          courseTitle: title,
          grade: grade,
          credits: double.parse(credits),
          term: term,
        ),
      );
    }

    return courses;
  }

  /// Converts a list of [CompletedCourse] to a formatted JSON string.
  static String coursesToJson(List<CompletedCourse> courses) {
    return const JsonEncoder.withIndent(
      '    ',
    ).convert(courses.map((c) => c.toJson()).toList());
  }
}
