import 'package:flutter/material.dart';

class AiAdvisorPage extends StatefulWidget {
  const AiAdvisorPage({super.key});

  @override
  State<AiAdvisorPage> createState() => _AiAdvisorPageState();
}

class _AiAdvisorPageState extends State<AiAdvisorPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    // TODO: Implement send message functionality
    print('Sending message: ${_messageController.text}');
    _messageController.clear();
  }

  void _handleSuggestion(String suggestion) {
    // TODO: Implement suggestion handling
    print('Suggestion selected: $suggestion');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: .min,
          children: [
            welcomeHeader(context),

            messageField(),

            questionSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget welcomeHeader(BuildContext context) {
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
            onTap: () => _handleSuggestion('Help me plan my schedule'),
          ),
          SuggestionChip(
            label: 'Find classes for me',
            icon: Icons.search,
            onTap: () => _handleSuggestion('Find classes for me'),
          ),
          SuggestionChip(
            label: 'Explain prerequisites',
            icon: Icons.school,
            onTap: () => _handleSuggestion('Explain prerequisites'),
          ),
          SuggestionChip(
            label: 'Course recommendations',
            icon: Icons.lightbulb_outline,
            onTap: () => _handleSuggestion('Course recommendations'),
          ),
        ],
      ),
    );
  }

  Widget messageField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Ask anything',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              tooltip: 'Send',
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
