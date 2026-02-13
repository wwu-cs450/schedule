import 'package:client/domain/handlers/ai_handler.dart';
import 'package:client/views/ai_advisor_page/ai_welcome_view.dart';
import 'package:client/views/ai_advisor_page/loading_animation.dart';
import 'package:client/views/ai_advisor_page/message_text_box.dart';
import 'package:client/views/ai_advisor_page/messages.dart';
import 'package:flutter/material.dart';

class AiAdvisorPage extends StatefulWidget {
  const AiAdvisorPage({super.key});

  @override
  State<AiAdvisorPage> createState() => _AiAdvisorPageState();
}

class _AiAdvisorPageState extends State<AiAdvisorPage> {
  final AiHandler aiHandler = ServerAiHandler();
  bool welcomeState = true;
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (welcomeState) {
      setState(() {
        welcomeState = false;
      });
    }

    final responseFuture = aiHandler.sendMessage(message);
    setState(() {
      // Refresh UI to show user message immediately
      _isLoading = true;
    });
    await responseFuture;
    setState(() {
      // Refresh UI to show AI response
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (welcomeState) {
      return AiWelcomeView(onSendMessage: _sendMessage);
    } else {
      return Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount:
                      aiHandler.messageHistory.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoading &&
                        index == aiHandler.messageHistory.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: LoadingAnimation(),
                      );
                    }
                    final message = aiHandler.messageHistory[index];
                    if (message['role'] == 'assistant') {
                      return AiMessage(message: message['content'] ?? '');
                    } else {
                      return UserMessage(message: message['content'] ?? '');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: MessageTextBox(onSend: _sendMessage),
              ),
              const SizedBox(height: 8),
              Text(
                'AI can make mistakes. Double-check important info.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      );
    }
  }
}
