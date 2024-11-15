String getCoursePrerequisite(String text) {
  final lines = text.split('\n');
  final startIndex =
      lines.indexWhere((line) => line.startsWith('Prerequisite'));

  if (startIndex == -1) {
    return 'No Prerequisites';
  }

  final endIndex = lines.indexWhere((line) => line.startsWith('Distribution'));
  final prerequisiteLines = lines.sublist(startIndex + 1, endIndex);
  return prerequisiteLines.join('\n');
}
