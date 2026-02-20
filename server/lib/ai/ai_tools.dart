import 'package:common/graduation_requirements.dart';
import 'package:ollama_dart/ollama_dart.dart';

class AiTools {
  static List<Map> getUserGraduationRequirements() {
    final graduationRequirements = GraduationRequirements(
      majorRequirements: [computerScienceBS_2023_2024],
    );
    return graduationRequirements.allRequiredCourses
        .map((course) => course.toJson())
        .toList();
  }
}

final availableFunctions = {
  'getUserGraduationRequirements': AiTools.getUserGraduationRequirements,
};

final List<Tool> tools = [
  Tool(
    function: ToolFunction(
      name: 'getUserGraduationRequirements',
      description: 'Get the user\'s graduation requirements.',
      parameters: {'type': 'object', 'properties': {}, 'required': []},
    ),
  ),
];
