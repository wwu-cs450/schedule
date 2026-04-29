import 'package:client/domain/models/llm_response.dart';
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

  final LLMResponse message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            thinkSection(),
            GptMarkdown(
              message.mainMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget thinkSection() {
    if (message.think == null || message.think!.isEmpty) {
      return const SizedBox.shrink();
    }

    return CollapsibleThinkSection(thinkText: message.think!);
  }
}

class CollapsibleThinkSection extends StatefulWidget {
  const CollapsibleThinkSection({required this.thinkText, super.key});

  final String thinkText;

  @override
  State<CollapsibleThinkSection> createState() =>
      _CollapsibleThinkSectionState();
}

class _CollapsibleThinkSectionState extends State<CollapsibleThinkSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _isExpanded
          ? BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thinking',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                widget.thinkText,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
        ],
      ),
    );
  }
}
