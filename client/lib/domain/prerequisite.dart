String getCoursePrerequisite(String text) {
  final lines = text.split('\n');
  final startIndex =
      lines.indexWhere((line) => line.startsWith('Prerequisite')) + 1;
  final endIndex = lines.indexWhere((line) => line.startsWith('Distribution'));
  final prerequisiteLines = lines.sublist(startIndex, endIndex);
  return prerequisiteLines.join('\n');
}
