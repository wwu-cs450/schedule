// ignore_for_file: type_annotate_public_apis

import 'package:schedule/meeting_time.dart';
import 'package:universal_html/parsing.dart';

import 'package:schedule/course.dart';
import 'package:schedule/get_html.dart';
import 'package:schedule/class.dart';
import 'package:schedule/instructor.dart';
import 'package:schedule/term.dart';
import 'package:schedule/campus.dart';

void addClass(var node, Course course) {
  try {
    final termCode =
        Term.instances.elementAt(0); //Term should be initialized before this
    //not enough terms, there should be a summer for 23 and 24 for now it will be 2239.
    int maxEnrollment = 0;
    try {
      maxEnrollment = int.parse(node[26]!.text);
    }
    // ignore: empty_catches
    catch (e) {}
    String schedule = 'TBA';
    try {
      schedule = node[32]!.text;
    }
    // ignore: empty_catches
    catch (e) {}
    if (schedule == ' ' || schedule == '') {
      schedule = 'TBA';
    }
    final String classroom = node[34]!.text;
    final List<String> instructorStrings = node[36]!.text.split(', ');
    final Set<Instructor> instructors = {};
    for (final instructorString in instructorStrings) {
      instructors.add(Instructor(instructorString));
    }
    Campus campusCode = Campus.instances.elementAt(0);
    for (final places in Campus.instances) {
      if (places.code == node[38]!.text) {
        campusCode = places;
      }
    }
    Class(
      course,
      termCode,
      maxEnrollment,
      MeetingTime.fromString(schedule),
      classroom,
      instructors,
      campusCode,
    );
  } catch (e) {
    throw Exception('Failed to add Class.');
  }
}

//Subject and Department are different categories for the same input. To scrape this we need to GET each search
//query with the defined list of departments and subjects classes. This requires a small rewrite when calling fetch_html
//and a method to get the already defined lists from their respective classes.
void addCourse(var node) {
  try {
    final bool generalStudies = (node[16].text != null);

    var courseLevelInt = 404;
    String courseLevel = node[4]!.text +
        node[6]!.text +
        node[8]!.text +
        node[10]!.text +
        node[12]!.text;
    courseLevel = courseLevel.replaceAll(RegExp(r'\D'), '');
    courseLevelInt = int.parse(courseLevel);
    if (courseLevelInt > 300) {
      courseLevel = 'upper';
    } else {
      courseLevel = 'lower';
    }
    final String courseDept = node[2]!.text;
    final String courseTitle = node[20]!.text;
    String courseNumber =
        '404'; // Store courseNumber as a string to accommodate labs
    courseNumber = node[0]!.text;
    //Course credits have a range on openClassRoom IE 1-16 instead of one value. +Some are half a credit
    double courseCreditsMin = 404;
    double courseCreditsMax = 404;
    String credits = node[18]!.text;
    credits = credits.replaceAll(RegExp(r'\D'), '');
    if (double.tryParse(credits) != null) {
      courseCreditsMin = double.tryParse(credits)!;
      courseCreditsMax = courseCreditsMin;
    } else if (credits.contains('-') && credits.length >= 3) {
      courseCreditsMin = double.tryParse(credits.split('-')[0]) ?? 0;
      courseCreditsMax =
          double.tryParse(credits.split('-')[1]) ?? courseCreditsMin;
    } else {
      throw FormatException(
        "Neither a single number nor of the format 'n-n' : ",
        credits,
      );
    }
    final currentCourse = Course(
      courseDept,
      courseDept, //Change to subject later when we get fetch_html by Dept/Subj working along with getting the sets from Dept/Subj classes.
      courseTitle,
      courseNumber,
      courseLevel,
      courseCreditsMin,
      courseCreditsMax,
      generalStudies,
    );
    addClass(node, currentCourse);
  } catch (e) {
    throw Exception('Failed to add course.');
  }
}

Future<void> loadHtmlIn() async {
  try {
    final document = await fetchHtml();
    final htmlDoc = parseHtmlDocument(document);
    final classTable = htmlDoc.getElementById('resulttable');
    if (classTable == null) {
      throw Exception('Class Table is empty.');
    }
    final evenRows = classTable.getElementsByClassName('evenrow');
    final oddRows = classTable.getElementsByClassName('oddrow');
    for (final row in evenRows) {
      addCourse(row.childNodes);
    }
    for (final row in oddRows) {
      addCourse(row.childNodes);
    }
  } catch (e) {
    throw Exception('Html Skimming Failed.');
  }
}
