import 'dart:typed_data';
import 'package:client/domain/pdf_helper.dart';
import 'package:common/completed_course.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';

class PdfUploadPage extends StatefulWidget {
  const PdfUploadPage({required this.onCoursesParsed, super.key});

  final void Function(List<CompletedCourse>) onCoursesParsed;

  @override
  PdfUploadPageState createState() => PdfUploadPageState();
}

class PdfUploadPageState extends State<PdfUploadPage> {
  bool _isLoading = false;
  String _selectedTab = 'Transcript'; // 'Transcript' or 'Audit'

  Future<void> extractPdfText(Uint8List pdfBytes) async {
    try {
      // Extract text from PDF using JavaScript interop
      final String extractedText = await PdfHelper.extractTextFromPDF(pdfBytes);
      final classes = PdfHelper.parseTranscriptPdfText(extractedText);
      widget.onCoursesParsed(classes);
    } catch (e) {
      throw Exception('Error extracting text from PDF: $e');
    }
  }

  Future<void> getPdfText() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final Uint8List pdfBytes = await PdfHelper.selectPdf();
      await extractPdfText(pdfBytes);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        width: 500,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(spacing: 8, children: [tab('Transcript'), tab('Audit')]),
            UploadBox(
              isLoading: _isLoading,
              onClick: _isLoading ? null : getPdfText,
            ),
          ],
        ),
      ),
    );
  }

  Widget tab(String label) {
    final isSelected = _selectedTab == label;
    const tabColor = Colors.blue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? tabColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? tabColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? tabColor : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  const UploadBox({required this.onClick, required bool isLoading, super.key})
    : _isLoading = isLoading;

  final bool _isLoading;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClick,
        behavior: HitTestBehavior.translucent,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: Colors.grey.withValues(alpha: 0.4),
            strokeWidth: 1,
            dashPattern: const [3, 2],
            radius: Radius.circular(8),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 210,
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Uploading PDF...',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: 'Drag a file or '),
                            TextSpan(
                              text: 'click to upload',
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
