// File: lib/views/audit_view.dart

import 'package:flutter/material.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({required this.extractedText, super.key});
  final String extractedText;

  /// Extracts sections from the provided [extractedText] based on headers.
  /// Returns a list of [Section] objects containing headers and their contents.
  List<Section> extractSections(String extractedText) {
    final RegExp headerRegex = RegExp(
      r'((?:[A-Z]{3,}|GS)[A-Z\s&]*)\s*\((?:RG|R)\s*\d+(?:\s*L\d+)?\)',
      caseSensitive: true,
    );

    final matches = headerRegex.allMatches(extractedText).toList();
    final List<Section> sections = [];
    final List<String> headers = [];

    // Print total matches

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
      final nextHeaderIndex = nextHeader != null
          ? extractedText.indexOf(nextHeader)
          : extractedText.length;

      final content = cleanContent(
        extractedText.substring(headerIndex, nextHeaderIndex).trim(),
      );
      sections.add(Section(header: header, content: content));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    // Extract the sections with titles
    final List<Section> sections = extractSections(extractedText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sections.isNotEmpty
            ? ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
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
                          key: Key('section_header'),
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
                },
              )
            : const Center(
                child: Text(
                  'No sections found.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}

String cleanContent(String content) {
  return content.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class Section {
  Section({required this.header, required this.content});
  final String header;
  final String content;
}
