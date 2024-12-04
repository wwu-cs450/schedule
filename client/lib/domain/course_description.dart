// File: course_description.dart

String getCourseDescription(String text) {
  // Find the keyword "Credits" to mark the end of the description
  final int creditsIndex = text.indexOf('Credits');

  if (creditsIndex == -1) {
    return 'No Description'; // Handle case where "Credits" is not present
  }

  // Extract text before "Credits"
  final String beforeCredits = text.substring(0, creditsIndex);

  // Use regex to match and remove the course title
  // Matches course code followed by multiple spaces, a title, and double spaces
  final RegExp titlePattern = RegExp(r'^[A-Z]+\s+\d+\s{2,}.*?\s{2,}');
  final String descriptionOnly = beforeCredits.replaceFirst(titlePattern, '');

  return descriptionOnly.trim();
}
