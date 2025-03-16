import 'dart:typed_data';

import 'package:client/domain/course_description.dart';
import 'package:client/domain/pdf_helper.dart';
import 'package:client/domain/prerequisite.dart';
import 'package:flutter/material.dart';

class BulletinPdfView extends StatefulWidget {
  const BulletinPdfView({super.key});

  @override
  BulletinPdfViewState createState() => BulletinPdfViewState();
}

class BulletinPdfViewState extends State<BulletinPdfView> {
  String? _courseDescription;
  String? _coursePrerequisite;
  bool _isLoading = false;

  Future<Uint8List> selectPdf() async {
    try {
      final Uint8List pdfBytes = await PdfHelper.selectPdf();
      return pdfBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> extractPdfText(Uint8List pdfBytes) async {
    try {
      final String extractedText = await PdfHelper.extractTextFromPDF(pdfBytes);
      setState(() {
        _courseDescription = getCourseDescription(extractedText);
        _coursePrerequisite = getCoursePrerequisite(extractedText);
      });
    } catch (e) {
      throw Exception('Error extracting text from PDF: $e');
    }
  }

  Future<void> getPdfText() async {
    try {
      setState(() {
        _isLoading = true;
        _courseDescription = null;
        _coursePrerequisite = null;
      });

      final Uint8List pdfBytes = await selectPdf();
      final String extractedText = await PdfHelper.extractTextFromPDF(pdfBytes);

      setState(() {
        _courseDescription = getCourseDescription(extractedText);
        _coursePrerequisite = getCoursePrerequisite(extractedText);
      });

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
    return Scaffold(
      appBar: AppBar(title: const Text('Bulletin Scanner'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
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
                  : Column(
                    children: [
                      Text(
                        _courseDescription ?? '',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _coursePrerequisite ?? '',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
