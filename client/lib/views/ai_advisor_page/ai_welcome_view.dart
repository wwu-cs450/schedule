import 'package:client/views/ai_advisor_page/message_text_box.dart';
import 'package:client/views/ai_advisor_page/suggestion_chip.dart';
import 'package:flutter/material.dart';

class AiWelcomeView extends StatelessWidget {
  const AiWelcomeView({required this.onSendMessage, super.key});

  final void Function(String) onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: .min,
          children: [
            welcomeMessage(context),
            MessageTextBox(onSend: onSendMessage),
            questionSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget welcomeMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        'How can I help?',
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget questionSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24,
        bottom: 32,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          SuggestionChip(
            label: 'Help me plan my schedule',
            icon: Icons.calendar_today,
            onTap: () => onSendMessage('Help me plan my schedule'),
          ),
          SuggestionChip(
            label: 'Find classes for me',
            icon: Icons.search,
            onTap: () => onSendMessage('Find classes for me'),
          ),
          SuggestionChip(
            label: 'Explain prerequisites',
            icon: Icons.school,
            onTap: () => onSendMessage('Explain prerequisites'),
          ),
          SuggestionChip(
            label: 'Course recommendations',
            icon: Icons.lightbulb_outline,
            onTap: () => onSendMessage('Course recommendations'),
          ),
        ],
      ),
    );
  }
}
