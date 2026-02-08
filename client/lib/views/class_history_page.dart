import 'package:client/domain/handlers/class_storage.dart';
import 'package:client/views/pdf_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassHistoryPage extends StatelessWidget {
  const ClassHistoryPage({super.key});

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
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  _header(context),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: storage.classes.length,
                        itemBuilder: (context, index) {
                          final course = storage.classes[index];
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

  Widget _header(BuildContext context) {
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
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 8),
                  Text('All Terms'),
                ],
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
