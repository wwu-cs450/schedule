import 'package:common/graduation_requirements.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:server/ai/schedule_data.dart';

class AiTools {
  static String getUserGraduationRequirements(Map<String, dynamic> _) {
    final graduationRequirements = GraduationRequirements(
      majorRequirements: [computerScienceBS_2023_2024],
    );
    return graduationRequirements.allRequiredCourses
        .map((course) => course.toJson())
        .toList()
        .toString();
  }

  static String getClassesForQuarter(Map<String, dynamic> args) {
    return ScheduleData().getClassesForQuarter(
      quarter: args['quarter'] as String?,
      year: args['year'] as String?,
      subject: args['subject'] as String?,
    );
  }

  static String getCourseInfo(Map<String, dynamic> args) {
    return ScheduleData().getCourseInfo(
      subjectCode: args['subjectCode'] as String?,
      courseCode: args['courseCode'] as String?,
    );
  }

  static String getSubjects(Map<String, dynamic> _) {
    return ScheduleData().getSubjects();
  }
}

/// All tool functions accept a `Map<String, dynamic>` of arguments and return
/// a `String` result that is sent back to the LLM.
final Map<String, String Function(Map<String, dynamic>)> availableFunctions = {
  'getUserGraduationRequirements': AiTools.getUserGraduationRequirements,
  'getClassesForQuarter': AiTools.getClassesForQuarter,
  'getCourseInfo': AiTools.getCourseInfo,
  'getSubjects': AiTools.getSubjects,
};

final List<Tool> tools = [
  Tool(
    function: ToolFunction(
      name: 'getUserGraduationRequirements',
      description:
          'Get all the courses required for the student\'s graduation '
          '(CS BS major). Returns the list of required courses with credits.',
      parameters: {
        'type': 'object',
        'properties': {},
        'required': [],
      },
    ),
  ),
  Tool(
    function: ToolFunction(
      name: 'getClassesForQuarter',
      description:
          'Get the actual class schedule for a specific academic quarter '
          'and year. Returns classes with instructor, meeting times, room, '
          'enrollment status, and capacity. Use this when the student asks '
          'what classes are being offered or wants to plan their schedule.',
      parameters: {
        'type': 'object',
        'properties': {
          'quarter': {
            'type': 'string',
            'description':
                'The academic quarter to look up. '
                'One of: FAL, WTR, SPR, SUM1, SUM2. '
                'Defaults to the next upcoming quarter if omitted.',
            'enum': ['FAL', 'WTR', 'SPR', 'SUM1', 'SUM2'],
          },
          'year': {
            'type': 'string',
            'description':
                'The academic year (e.g. "2026"). '
                'Defaults to the current year if omitted.',
          },
          'subject': {
            'type': 'string',
            'description':
                'Filter by subject code (e.g. "CPTR", "MATH", "ENGR"). '
                'If omitted, returns classes for all subjects.',
          },
        },
        'required': [],
      },
    ),
  ),
  Tool(
    function: ToolFunction(
      name: 'getCourseInfo',
      description:
          'Look up detailed course information from the university bulletin '
          'catalog including course description and prerequisites. '
          'Use this when the student asks about prerequisites, course '
          'details, or what a course covers.',
      parameters: {
        'type': 'object',
        'properties': {
          'subjectCode': {
            'type': 'string',
            'description':
                'The subject code (e.g. "CPTR", "MATH"). '
                'If only subjectCode is given, returns all courses '
                'under that subject.',
          },
          'courseCode': {
            'type': 'string',
            'description':
                'The specific course number (e.g. "142", "250"). '
                'If omitted, returns all courses for the subject.',
          },
        },
        'required': ['subjectCode'],
      },
    ),
  ),
  Tool(
    function: ToolFunction(
      name: 'getSubjects',
      description:
          'Get a list of all available subject codes and their full names '
          '(e.g. CPTR = Computer Science). Use this when you need to know '
          'valid subject codes.',
      parameters: {
        'type': 'object',
        'properties': {},
        'required': [],
      },
    ),
  ),
];
