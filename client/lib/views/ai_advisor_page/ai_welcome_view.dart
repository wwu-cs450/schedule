import 'package:client/domain/handlers/class_storage.dart';
import 'package:client/views/ai_advisor_page/message_text_box.dart';
import 'package:client/views/ai_advisor_page/suggestion_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiWelcomeView extends StatelessWidget {
  const AiWelcomeView({required this.onSendMessage, super.key});

  final void Function(String) onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassStorage>(
      builder: (context, storage, child) {
        return Center(
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: .min,
              children: [
                welcomeMessage(context, storage.classes.isNotEmpty),
                MessageTextBox(onSend: onSendMessage),
                questionSuggestions(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget welcomeMessage(BuildContext context, bool transcriptUploaded) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        spacing: 16,
        children: [
          Text(
            'How can I help?',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
          ),

          if (!transcriptUploaded)
            Text(
              'To get personalized advice, upload your transcript in the Class History tab',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
        ],
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
            label: 'What classes do I still need to take?',
            icon: Icons.list_alt,
            onTap: () => onSendMessage('What classes do I still need to take?'),
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
