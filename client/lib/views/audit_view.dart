import 'package:flutter/material.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({required this.extractedText, super.key});
  final String extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Page'),
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
