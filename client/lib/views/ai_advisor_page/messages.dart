import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          constraints: const BoxConstraints(maxWidth: 600),
          child: SelectableText(message, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class AiMessage extends StatelessWidget {
  const AiMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: SelectionArea(
        child: GptMarkdown(message, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
