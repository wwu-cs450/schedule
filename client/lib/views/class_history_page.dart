import 'package:client/domain/handlers/class_storage.dart';
import 'package:client/views/pdf_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassHistoryPage extends StatefulWidget {
  const ClassHistoryPage({super.key});

  @override
  State<ClassHistoryPage> createState() => _ClassHistoryPageState();
}

class _ClassHistoryPageState extends State<ClassHistoryPage> {
  String? selectedTerm;

  Future<dynamic> showUploadDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 500,
          height: 350,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              PdfUploadPage(
                onCoursesParsed: (parsedCourses) async {
                  await ClassStorage().addClasses(parsedCourses);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassStorage>(
      builder: (context, storage, child) {
        if (storage.classes.isEmpty) {
          return PdfUploadPage(
            onCoursesParsed: (parsedCourses) async {
              await ClassStorage().addClasses(parsedCourses);
            },
          );
        } else {
          // Get unique terms from the classes
          final availableTerms = storage.classes
              .map((c) => c.term)
              .toSet()
              .toList();

          // Filter classes based on selected term
          final filteredClasses = selectedTerm == null
              ? storage.classes
              : storage.classes.where((c) => c.term == selectedTerm).toList();

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  _header(context, availableTerms),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: filteredClasses.length,
                        itemBuilder: (context, index) {
                          final course = filteredClasses[index];
                          return ListTile(
                            title: Text(
                              '${course.course}: ${course.courseTitle}',
                            ),
                            subtitle: Text(
                              'Credits: ${course.credits} | Term: ${course.term} | Status: ${course.status.toDisplayString()}',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _header(BuildContext context, List<String> availableTerms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Class History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _uploadNewButton(context),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            FilterChip(
              label: 'All Terms',
              isSelected: selectedTerm == null,
              onTap: () {
                setState(() {
                  selectedTerm = null;
                });
              },
            ),
            ...availableTerms.map(
              (term) => FilterChip(
                label: term,
                isSelected: selectedTerm == term,
                onTap: () {
                  setState(() {
                    selectedTerm = term;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextButton _uploadNewButton(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.upload),
      label: const Text('Upload New'),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => showUploadDialog(context),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFF0EEE2) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Color(0xFF656950) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
