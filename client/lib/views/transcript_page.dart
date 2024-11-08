// File: lib/transcript_page.dart
import 'package:flutter/material.dart';

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({required this.extractedText, super.key});
  final String extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcript Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            extractedText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
