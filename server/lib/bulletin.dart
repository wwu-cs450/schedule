import 'dart:async';
import 'dart:io';

// clear; dart run bin/server.dart --bulletin='../bulletin/bulletin.txt'

Future<void> bulletin(String readPath) async {
  final readFile = File.fromUri(Uri.file(readPath));
  if (!readFile.existsSync()) {
    print('File not found.');
    exit(0);
  }
  final lines = await readFile.readAsLines();
  int i = 0;
  while (true) {
    final line = lines[i++];
    if (isStartOfCourseList(line)) {
      break;
    }
  }
  String courses =
      'subjectCode\tcourseCode\tcourseName\t'
      'courseCreditsMin\tcourseCreditsMax\tcourseCreditsTotal\t'
      'writingInDiscipline\tdescription';

  String subjectCode = '';
  String subjects = '';
  while (true) {
    RegExpMatch? match;
    String line = lines[i++];
    if (isEndOfCourseList(line)) {
      break;
    }
    if (isPageNumber(line)) {
      continue;
    }
    if ((match = matchSubjectHeading(line)) != null) {
      subjectCode = match!.group(1)!;
      subjects += '$subjectCode\t${match.group(2)!}\n';
      continue;
    }
    if (subjectCode == 'PEAC') {
      continue;
    }
    if ((match = matchCourseStart(line)) == null) {
      courses += line;
      continue;
    }
    while (true) {
      if ((match = matchCourse(line)) != null) {
        break;
      }
      line += lines[i++];
    }
    final courseSubjectCode = match!.group(1)!;
    if (courseSubjectCode != subjectCode) {
      print('Error: $subjectCode != $courseSubjectCode');
      exit(0);
    }
    final String courseCode = match.group(2)!;
    String courseName = match.group(3)!.trim();
    late bool writingInDiscipline;
    if (courseName.endsWith('(WD)')) {
      writingInDiscipline = true;
      courseName = courseName.substring(0, courseName.length - 4).trim();
    } else {
      writingInDiscipline = false;
    }
    final courseCredits = match.group(4)!.trim();
    match = matchCourseCredits(courseCredits)!;
    final courseCreditsMin = match.group(1)!;
    final courseCreditsMax = match.group(3) ?? courseCreditsMin;
    final courseCreditsTotal = match.group(5) ?? courseCreditsMax;
    courses +=
        '\n$subjectCode\t$courseCode\t$courseName\t'
        '$courseCreditsMin\t$courseCreditsMax\t$courseCreditsTotal\t'
        '$writingInDiscipline\t';
  }

  final subjectsFile = File.fromUri(Uri.file('../client/assets/subjects.txt'));
  subjectsFile.writeAsStringSync(subjects);

  final coursesFile = File.fromUri(Uri.file('../client/assets/courses.txt'));
  coursesFile.writeAsStringSync(courses);
}

bool isEndOfCourseList(String line) {
  return line == ' Financial Information | 205 ';
}

bool isStartOfCourseList(String line) {
  return line == 'COURSES ';
}

bool isPageNumber(String line) {
  return RegExp(
        r'\d+ \| Walla Walla University 20\d{2} -20\d{2} Undergraduate Bulletin  ',
      ).hasMatch(line) ||
      RegExp(r' Courses \| \d+ ').hasMatch(line);
}

RegExpMatch? matchCourse(String line) {
  return RegExp(
    r'^([a-zA-Z]{3,4}) ([0-9LP]{3,4}) - (.*?)(?=(\([0-9][^)]*\)))',
  ).firstMatch(line);
}

RegExpMatch? matchCourseCredits(String line) {
  return RegExp(
    r'\(([0-9.]+)\s?(-\s?([0-9.]+))?(;?\s?([0-9.]+))?\)',
  ).firstMatch(line);
}

RegExpMatch? matchCourseStart(String line) {
  return RegExp('^([a-zA-Z]{3,4}) ([0-9LP]{3,4}) - ').firstMatch(line);
}

RegExpMatch? matchSubjectHeading(String line) {
  return RegExp(r'^([a-zA-Z]{3,4}) - (.+)$').firstMatch(line);
}
