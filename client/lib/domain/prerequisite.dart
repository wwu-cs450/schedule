String getCoursePrerequisite(String text) {
  // Look for the keyword "Prerequisite" to mark the start of prerequisites
  final int prerequisiteIndex = text.indexOf('Prerequisite');

  if (prerequisiteIndex == -1) {
    return 'No Prerequisites'; // Handle case where "Prerequisite" is not present
  }

  // Extract text after "Prerequisite" and before "Distribution"
  final int distributionIndex = text.indexOf('Distribution', prerequisiteIndex);
  final String prerequisites = (distributionIndex == -1)
      ? text.substring(prerequisiteIndex + 'Prerequisite'.length).trim()
      : text
          .substring(
            prerequisiteIndex + 'Prerequisite'.length,
            distributionIndex,
          )
          .trim();

  // Return extracted prerequisites or default message
  return prerequisites.isEmpty ? 'No Prerequisites' : prerequisites;
}
