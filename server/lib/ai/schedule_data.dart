import 'dart:io';

import 'package:csv/csv.dart';

/// Singleton that loads and provides query methods for the class schedule
/// (scraped CSV) and the bulletin catalog (courses.txt).
class ScheduleData {
  factory ScheduleData() => _instance;

  ScheduleData._();
  static final ScheduleData _instance = ScheduleData._();

  /// Raw rows from class_data.csv.  Each inner list has 30 columns – see
  /// [_Col] for the column indices.
  List<List<String>> _scheduleRows = [];

  /// Bulletin entries keyed by "SUBJ CODE" (e.g. "CPTR 142").
  /// Values are maps with: subjectCode, courseCode, courseName, credits,
  /// writingInDiscipline, description (which often contains prerequisites).
  final Map<String, Map<String, String>> _bulletinCourses = {};

  /// Subject-code → full name mapping (e.g. CPTR → Computer Science).
  final Map<String, String> _subjects = {};

  // ── Column indices for class_data.csv ──────────────────────────────────

  static const int _colYear = 2;
  static const int _colSubject = 7;
  static const int _colSum1 = 8;
  static const int _colFal = 9;
  static const int _colWtr = 10;
  static const int _colSpr = 11;
  static const int _colSum2 = 12;
  static const int _colSection = 13;
  static const int _colTitle = 14;
  static const int _colCredits = 15;
  static const int _colStatus = 16;
  static const int _colEnrolled = 17;
  static const int _colCapacity = 18;
  static const int _colMeetingPattern = 21;
  static const int _colRoom = 22;
  static const int _colInstructor = 23;
  // ignore: unused_field
  static const int _colDescription = 24;
  static const int _colMode = 25;

  // ── Loading ────────────────────────────────────────────────────────────

  /// Loads class schedule CSV and bulletin data.  Call once at server startup.
  Future<void> load() async {
    await Future.wait([
      _loadSchedule(),
      _loadBulletin(),
      _loadSubjects(),
    ]);
    print(
      'ScheduleData loaded: '
      '${_scheduleRows.length} schedule rows, '
      '${_bulletinCourses.length} bulletin courses, '
      '${_subjects.length} subjects.',
    );
  }

  Future<void> _loadSchedule() async {
    final File file;
    if (Platform.localHostname == 'schedule-vm') {
      file = File('/var/www/html/assets/class_data.csv');
    } else {
      file = File('../client/assets/class_data.csv');
    }
    if (!file.existsSync()) {
      return;
    }
    final csv = await file.readAsString();
    _scheduleRows = const CsvToListConverter(eol: '\n', shouldParseNumbers: false)
        .convert(csv)
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();
  }

  Future<void> _loadBulletin() async {
    final file = File('../client/assets/courses.txt');
    if (!file.existsSync()) {
      return;
    }
    final lines = await file.readAsLines();
    // First line is the header.
    for (var i = 1; i < lines.length; i++) {
      final parts = lines[i].split('\t');
      if (parts.length < 8) {
        continue;
      }
      final key = '${parts[0]} ${parts[1]}';
      _bulletinCourses[key] = {
        'subjectCode': parts[0],
        'courseCode': parts[1],
        'courseName': parts[2],
        'creditsMin': parts[3],
        'creditsMax': parts[4],
        'creditsTotal': parts[5],
        'writingInDiscipline': parts[6],
        'description': parts[7],
      };
    }
  }

  Future<void> _loadSubjects() async {
    final file = File('../client/assets/subjects.txt');
    if (!file.existsSync()) {
      return;
    }
    final lines = await file.readAsLines();
    for (final line in lines) {
      final parts = line.split('\t');
      if (parts.length >= 2) {
        _subjects[parts[0]] = parts[1];
      }
    }
  }

  // ── Quarter helpers ────────────────────────────────────────────────────

  /// Returns the name of the current academic quarter based on the month.
  String get currentQuarter {
    final month = DateTime.now().month;
    if (month >= 1 && month <= 3) {
      return 'WTR';
    }
    if (month >= 4 && month <= 6) {
      return 'SPR';
    }
    if (month == 7) {
      return 'SUM2';
    }
    if (month >= 8 && month <= 8) {
      return 'SUM1';
    }
    return 'FAL'; // Sep-Dec
  }

  /// Returns the next academic quarter after the current one.
  String get nextQuarter {
    return switch (currentQuarter) {
      'FAL' => 'WTR',
      'WTR' => 'SPR',
      'SPR' => 'SUM1',
      'SUM1' => 'SUM2',
      'SUM2' => 'FAL',
      _ => 'SPR',
    };
  }

  /// Map quarter abbreviation to the corresponding CSV column index.
  int _quarterColumn(String quarter) {
    return switch (quarter) {
      'SUM1' => _colSum1,
      'FAL' => _colFal,
      'WTR' => _colWtr,
      'SPR' => _colSpr,
      'SUM2' => _colSum2,
      _ => _colSpr,
    };
  }

  /// Friendly label for a quarter abbreviation.
  String _quarterLabel(String quarter) {
    return switch (quarter) {
      'SUM1' => 'Summer 1',
      'FAL' => 'Fall',
      'WTR' => 'Winter',
      'SPR' => 'Spring',
      'SUM2' => 'Summer 2',
      _ => quarter,
    };
  }

  // ── Query: schedule ────────────────────────────────────────────────────

  /// Get classes offered in a given quarter and year, optionally filtered
  /// by subject code (e.g. "CPTR").
  ///
  /// Returns a human-readable string the LLM can reason about.
  String getClassesForQuarter({
    String? quarter,
    String? year,
    String? subject,
  }) {
    quarter ??= nextQuarter;
    year ??= DateTime.now().year.toString();

    final qCol = _quarterColumn(quarter);

    final matching = _scheduleRows.where((row) {
      if (row[_colYear] != year) {
        return false;
      }
      // The course number appears in the quarter column if the class is
      // offered that quarter; otherwise the column is empty.
      if (row[qCol].trim().isEmpty) {
        return false;
      }
      if (subject != null &&
          row[_colSubject].toUpperCase() != subject.toUpperCase()) {
        return false;
      }
      return true;
    }).toList();

    if (matching.isEmpty) {
      return 'No classes found for '
          '${subject ?? "any subject"} in '
          '${_quarterLabel(quarter)} $year.';
    }

    final buffer = StringBuffer();
    buffer.writeln(
      'Classes offered in ${_quarterLabel(quarter)} $year'
      '${subject != null ? " for $subject" : ""}:',
    );
    buffer.writeln();

    for (final row in matching) {
      final courseNumber = row[qCol];
      final subj = row[_colSubject];
      buffer.writeln('$subj $courseNumber - ${row[_colTitle]}');
      buffer.writeln('  Credits: ${row[_colCredits]}');
      if (row[_colSection].isNotEmpty) {
        buffer.writeln('  Section: ${row[_colSection]}');
      }
      buffer.writeln('  Instructor: ${row[_colInstructor]}');
      buffer.writeln('  Schedule: ${row[_colMeetingPattern]}');
      if (row[_colRoom].isNotEmpty) {
        buffer.writeln('  Room: ${row[_colRoom]}');
      }
      buffer.writeln(
        '  Mode: ${row[_colMode] == "O" ? "Online" : "In Person"}',
      );
      buffer.writeln(
        '  Enrollment: ${row[_colEnrolled]}/${row[_colCapacity]} '
        '(${row[_colStatus]})',
      );
      buffer.writeln();
    }
    return buffer.toString();
  }

  // ── Query: bulletin ────────────────────────────────────────────────────

  /// Look up one or more courses in the bulletin.
  ///
  /// • If [courseCode] is given, returns info for that specific course
  ///   (e.g. subjectCode="CPTR", courseCode="352").
  /// • If only [subjectCode] is given, returns all courses under that
  ///   subject.
  String getCourseInfo({String? subjectCode, String? courseCode}) {
    if (subjectCode == null && courseCode == null) {
      return 'Please provide at least a subject code (e.g. CPTR) '
          'to look up bulletin information.';
    }

    if (subjectCode != null && courseCode != null) {
      final key = '${subjectCode.toUpperCase()} ${courseCode.toUpperCase()}';
      final entry = _bulletinCourses[key];
      if (entry == null) {
        return 'Course $key not found in the bulletin.';
      }
      return _formatBulletinEntry(entry);
    }

    // All courses for a subject.
    final subj = subjectCode!.toUpperCase();
    final entries =
        _bulletinCourses.values
            .where((e) => e['subjectCode'] == subj)
            .toList();
    if (entries.isEmpty) {
      return 'No courses found for subject $subj in the bulletin.';
    }
    final buffer = StringBuffer();
    buffer.writeln('Bulletin courses for $subj '
        '(${_subjects[subj] ?? subj}):');
    buffer.writeln();
    for (final entry in entries) {
      buffer.writeln(_formatBulletinEntry(entry));
      buffer.writeln();
    }
    return buffer.toString();
  }

  String _formatBulletinEntry(Map<String, String> entry) {
    final buffer = StringBuffer();
    buffer.writeln(
      '${entry["subjectCode"]} ${entry["courseCode"]} – '
      '${entry["courseName"]}',
    );
    buffer.writeln('  Credits: ${entry["creditsMin"]}'
        '${entry["creditsMin"] != entry["creditsMax"] ? "-${entry["creditsMax"]}" : ""}');
    if (entry['writingInDiscipline'] == 'true') {
      buffer.writeln('  Writing in the Discipline (WD)');
    }
    if (entry['description']!.isNotEmpty) {
      buffer.writeln('  Description: ${entry["description"]}');
    }
    return buffer.toString();
  }

  // ── Query: subjects ────────────────────────────────────────────────────

  /// Returns a list of all subject codes and full names.
  String getSubjects() {
    if (_subjects.isEmpty) {
      return 'No subject list available.';
    }
    final buffer = StringBuffer();
    buffer.writeln('Available subjects:');
    for (final entry in _subjects.entries) {
      buffer.writeln('  ${entry.key} – ${entry.value}');
    }
    return buffer.toString();
  }

  /// A short context string for the LLM system prompt summarizing what
  /// data is available and what quarter we're in.
  String get contextSummary {
    final now = DateTime.now();
    return 'Today is ${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}. '
        'The current academic quarter is ${_quarterLabel(currentQuarter)} '
        '${now.year}. '
        'The next quarter is ${_quarterLabel(nextQuarter)} ${now.year}. '
        'The schedule database covers years '
        '${_scheduleRows.map((r) => r[_colYear]).toSet().toList()..sort()}. '
        'The bulletin catalog contains ${_bulletinCourses.length} courses '
        'across ${_subjects.length} subjects.';
  }
}
