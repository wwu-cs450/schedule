import 'dart:typed_data';
import 'package:client/domain/class_storage.dart';
import 'package:client/domain/pdf_helper.dart'; // Import the Dart helper
import 'package:client/views/audit_view.dart';
import 'package:client/views/transcript_page.dart';

import 'package:flutter/material.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  PdfViewState createState() => PdfViewState();
}

class PdfViewState extends State<PdfView> {
  String? _parsedText;
  bool _isLoading = false;

  Future<Uint8List> selectPdf() async {
    return PdfHelper.selectPdf();
  }

  Future<void> extractPdfText(Uint8List pdfBytes) async {
    try {
      // Extract text from PDF using JavaScript interop
      final String extractedText = await PdfHelper.extractTextFromPDF(pdfBytes);
      setState(() {
        _parsedText = extractedText;
      });
    } catch (e) {
      throw Exception('Error extracting text from PDF: $e');
    }
  }

  Future<void> getPdfText() async {
    try {
      setState(() {
        _isLoading = true;
        _parsedText = null; // Clear previous text
      });

      final Uint8List pdfBytes = await selectPdf();
      await extractPdfText(pdfBytes);

      setState(() {
        _isLoading = false;
      });

      // After extracting text, prompt the user for categorization
      if (_parsedText != null && _parsedText!.isNotEmpty) {
        await _showCategoryDialog(_parsedText!);
      } else {
        setState(() {
          _parsedText = 'No text found in the PDF.';
        });
      }
    } catch (e) {
      setState(() {
        // Display only the exception message
        _parsedText = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showCategoryDialog(String extractedText) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Categorize PDF'),
          content: const Text('Is this PDF your Audit or Transcript?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to AuditPage
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AuditPage(extractedText: extractedText),
                  ),
                );
              },
              child: const Text('Audit'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to TranscriptPage
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            TranscriptPage(extractedText: extractedText),
                  ),
                );
              },
              child: const Text('Transcript'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optional: Add an AppBar for better navigation and aesthetics
      appBar: AppBar(title: const Text('PDF Upload'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better UI
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                key: const Key('Select PDF Button'),
                onPressed: getPdfText,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Text('Select PDF', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit Audit or Transcript to proceed'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('Clear Transcript Button'),
        onPressed: () {
          // Define the action here
          final notEmpty = ClassStorage().clearTranscript();
          if (!notEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No Transcript Stored')),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Transcript Cleared')));
          }
        },
        tooltip: 'Clear Transcript',
        child: const Icon(Icons.clear), // Tooltip for accessibility
      ),
    );
  }
}
