// File: lib/views/audit_view.dart

import 'package:client/domain/requirement_class.dart';
import 'package:flutter/material.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({required this.extractedText, super.key});
  final String extractedText;

  /// Extracts sections from the provided [extractedText] based on headers.
  /// Returns a list of [SimpleSection] objects containing headers and their contents.
  List<SimpleSection> extractSections(String extractedText) {
    final RegExp headerRegex = RegExp(
      r'((?:[A-Z]{3,}|GS)[A-Z\s&]*)\s*\((?:RG|R)\s*\d+(?:\s*L\d+)?\)',
      caseSensitive: true,
    );

    final matches = headerRegex.allMatches(extractedText).toList();
    final List<SimpleSection> sections = [];
    final List<String> headers = [];

    for (var i = 0; i < matches.length; i++) {
      final match = matches[i];
      final String header = match.group(0)!.trim();
      if (header.isEmpty) {
        continue;
      }
      headers.add(header);
    }

    for (var i = 0; i < headers.length; i++) {
      final header = headers[i];
      final nextHeader = i + 1 < headers.length ? headers[i + 1] : null;
      final headerIndex = extractedText.indexOf(header);
      final nextHeaderIndex =
          nextHeader != null
              ? extractedText.indexOf(nextHeader)
              : extractedText.length;

      final content = cleanContent(
        extractedText.substring(headerIndex, nextHeaderIndex).trim(),
      );
      sections.add(SimpleSection(header: header, content: content));
    }

    return sections;
  }

  static Requirement parseOverallUndergraduateRequirements(
    SimpleSection section,
  ) {
    final List<RequirementDetail> requirements = [];
    String status = 'Not Satisfied';

    String tempString = section.content;

    // Regular expression to match the initial part of the string
    final RegExp initialPartRegex = RegExp(
      r'^(OVERALL UNDERGRADUATE REQUIREMENTS \(RG \d+\) (Satisfied|Not Satisfied): OVERALL UNDERGRADUATE REQUIREMENTS )',
      caseSensitive: false,
    );

    // Match the initial part of the string
    final match = initialPartRegex.firstMatch(tempString);

    if (match != null) {
      // Set the status based on the captured value
      status = match.group(2)!;

      // Remove the matched part from the tempString
      tempString = tempString.substring(match.end).trim();
    }

    // Regular expression to match the "In Progress Courses" part
    final RegExp inProgressRegex = RegExp(
      r'(In Progress Courses \([A-Za-z0-9 ]+\) (Satisfied|Not Satisfied): In progress courses)',
      caseSensitive: false,
    );

    // Match the "In Progress Courses" part
    final inProgressMatch = inProgressRegex.firstMatch(tempString);

    if (inProgressMatch != null) {
      // Set the status based on the captured value
      final inProgressStatus = RequirementDetail(
        description: 'In Progress Courses',
        unitsRequired: 0.0,
        unitsCompleted: 0.0,
        unitsNeeded: 0.0,
        status: inProgressMatch.group(2) == 'Satisfied',
      );
      // Trim the tempString to remove everything after the "In Progress Courses" part
      tempString = tempString.substring(0, inProgressMatch.end).trim();
      requirements.add(inProgressStatus);
    }

    final RegExp requirementDetailRegex = RegExp(
      r"([A-Za-z0-9 ]+? \([A-Za-z0-9 ]+\)) (Satisfied|Not Satisfied): [A-Za-z0-9\'\s]+\.? · Units: ((\d+\.\d+) required, )?(\d+\.\d+) used(, (\d+\.\d+) needed)?",
      caseSensitive: false,
    );

    // Match each requirement detail
    final matches = requirementDetailRegex.allMatches(tempString);

    for (final match in matches) {
      final description = match.group(1)!.trim();
      final status = match.group(2)!.trim() == 'Satisfied';
      final unitsRequired =
          match.group(3) != null ? double.parse(match.group(4)!.trim()) : 0.0;
      final unitsCompleted = double.parse(match.group(5)!.trim());
      final unitsNeeded =
          match.group(6) != null ? double.parse(match.group(7)!.trim()) : 0.0;

      final requirementDetail = RequirementDetail(
        description: description,
        unitsRequired: unitsRequired,
        unitsCompleted: unitsCompleted,
        unitsNeeded: unitsNeeded,
        status: status,
      );

      requirements.add(requirementDetail);
    }

    return Requirement(
      title: section.header,
      status: status,
      details: requirements,
    );
  }

  static List<SimpleSection> parseNewGSFormat(String content) {
    final RegExp generalStudyRegex = RegExp(
      r'(GENERAL STUDIES \(RG 582\)) ([A-za-z ]+?):',
      caseSensitive: false,
    );
    final match = generalStudyRegex.firstMatch(content);
    //search the match for the string 'Not Satified' or 'Satisfied'

    final RegExp requirementDetailRegex = RegExp(
      r'GS:? ([A-Za-z ]+? (\(R ?\d+\) )?)Overall Requirement (Satisfied|Not Satisfied):',
      caseSensitive: false,
    );

    final List<SimpleSection> sections = [];
    final matches = [];
    if (match != null) {
      matches.add(match);
    }
    matches.addAll(requirementDetailRegex.allMatches(content));

    for (int i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);
      final String header = 'GS ${match.group(1)!.trim()}';
      final start = match.end;

      // Extract the content between the last match end and the current match start
      final sectionContent =
          content
              .substring(
                start,
                i + 1 < matches.length
                    ? matches.elementAt(i + 1).start
                    : content.length,
              )
              .trim();

      sections.add(SimpleSection(header: header, content: sectionContent));
    }

    return sections;
  }

  static List<SimpleSection> parseEngGSFormat(String content) {
    final RegExp generalStudyRegex = RegExp(
      r'(ENGINEERING GENERAL STUDIES \(RG 773\)) ([A-za-z ]+?):',
      caseSensitive: false,
    );
    final match = generalStudyRegex.firstMatch(content);

    final RegExp requirementDetailRegex = RegExp(
      r'([A-Z][a-zA-Z]{2,}(?:[ &][A-Za-z]+)* - Engineering General Studies \(R ?\d+\)) (Overall Requirement Not Satisfied|Satisfied):',
    );

    final List<SimpleSection> sections = [];
    final matches = [];
    if (match != null) {
      matches.add(match);
    }
    matches.addAll(requirementDetailRegex.allMatches(content));
    for (int i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);
      final String header = match.group(1)!.trim();
      final start = match.end;

      // Determine the end index for the substring
      final end =
          i + 1 < matches.length
              ? matches.elementAt(i + 1).start
              : content.length;

      final sectionContent = content.substring(start, end).trim();
      sections.add(SimpleSection(header: header, content: sectionContent));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    // Extract the sections with titles
    final List<SimpleSection> sections = extractSections(extractedText);
    if (sections.isEmpty) {
      return const Center(
        child: Text('No sections found.', style: TextStyle(fontSize: 16)),
      );
    }

    final Requirement overallUndergraduateRequirements =
        parseOverallUndergraduateRequirements(
          sections.firstWhere(
            (section) =>
                section.header == 'OVERALL UNDERGRADUATE REQUIREMENTS (RG 639)',
          ),
        );

    final int index = sections.indexWhere(
      (section) => section.header == 'GENERAL STUDIES (RG 582)',
    );

    if (index != -1) {
      final generalStudiesSection = sections[index];

      final int wordCount =
          generalStudiesSection.content.split(RegExp(r'\s+')).length;

      if (wordCount > 50) {
        final List<SimpleSection> newSections = parseNewGSFormat(
          generalStudiesSection.content,
        );
        sections.removeAt(index);
        sections.insertAll(index, newSections);
      }
    } else {
      final int index = sections.indexWhere(
        (section) => section.header == 'ENGINEERING GENERAL STUDIES (RG 773)',
      );
      if (index != -1) {
        final generalStudiesSection = sections[index];

        final List<SimpleSection> newSections = parseEngGSFormat(
          generalStudiesSection.content,
        );
        sections.removeAt(index);
        sections.insertAll(index, newSections);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Audit Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sections.length + 1, // Increase itemCount by 1
          itemBuilder: (context, index) {
            if (index < sections.length) {
              final section = sections[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the header
                    SelectableText(
                      key: Key('section_header_$index'),
                      section.header,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Display the content
                    SelectableText(
                      section.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            } else {
              // Display the overall undergraduate requirements section
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the header
                    SelectableText(
                      key: Key('overall_undergraduate_requirements_header'),
                      overallUndergraduateRequirements.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Display the requirements
                    ...overallUndergraduateRequirements.details.map(
                      (requirement) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              requirement.description,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: SelectableText(
                                'Required: ${requirement.unitsRequired}, Completed: ${requirement.unitsCompleted}, Needed: ${requirement.unitsNeeded}, Status: ${requirement.status ? 'Satisfied' : 'Not Satisfied'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

String cleanContent(String content) {
  var updatedContent = '';
  updatedContent = content.replaceAll(RegExp(r'\s+'), ' ').trim();
  updatedContent = updatedContent.replaceAll(RegExp(r' Page \d+ of \d+'), '');
  return updatedContent;
}

class SimpleSection {
  SimpleSection({required this.header, required this.content});
  final String header;
  String content;
}
