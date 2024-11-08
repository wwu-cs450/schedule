String getCourseDescription(String text) {
  final lines = text.split('\n');
  const startIndex = 1; // skip the first line (course title)
  final endIndex = lines.indexWhere((line) => line.startsWith('Credits'));
  final descriptionLines = lines.sublist(startIndex, endIndex);
  return descriptionLines.join('\n');
}
