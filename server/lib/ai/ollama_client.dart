import 'package:ollama_dart/ollama_dart.dart';
import 'package:server/ai/ai_tools.dart';

/// Client wrapper for interacting with the Ollama LLM server.
class AiChatClient {
  AiChatClient({
    this.baseUrl = 'http://ollama.cs.wallawalla.edu:11434/api',
    this.model = 'qwen3',
  });

  final String baseUrl;
  final String model;

  static const String _baseSystemPrompt =
      'You are a helpful assistant that helps students with their class schedules. '
      'You have access to tools that can provide information about the user\'s '
      'currently registered classes. Use these tools as needed to answer the '
      'user\'s questions about their schedule.';

  String _buildSystemPrompt(String? courseHistory) {
    if (courseHistory == null || courseHistory.isEmpty) {
      return _baseSystemPrompt;
    }
    return '$_baseSystemPrompt\n\n'
        'The student has uploaded their class transcript. '
        'Here is their course history:\n'
        '$courseHistory\n\n'
        'Use this transcript data to help the student understand what classes '
        'they have already taken, what requirements they may have fulfilled, '
        'and what classes they still need to take.';
  }

  Future<String> chat(
    List<Map<String, String>> conversationHistory, {
    String? courseHistory,
  }) async {
    final client = OllamaClient(baseUrl: baseUrl);

    final messages = <Message>[
      Message(
        role: MessageRole.system,
        content: _buildSystemPrompt(courseHistory),
      ),

      // Convert the incoming conversation history to Ollama Message objects.
      for (final entry in conversationHistory)
        Message(
          role: _parseRole(entry['role']!),
          content: entry['content'] ?? '',
        ),
    ];

    while (true) {
      final response = await client.generateChatCompletion(
        request: GenerateChatCompletionRequest(
          model: model,
          messages: messages,
          tools: tools,
          options: RequestOptions(numPredict: -1),
        ),
      );

      messages.add(response.message);

      if (response.message.toolCalls != null &&
          response.message.toolCalls!.isNotEmpty) {
        for (final toolCall in response.message.toolCalls!) {
          final functionName = toolCall.function?.name;
          if (functionName != null &&
              availableFunctions.containsKey(functionName)) {
            final result = availableFunctions[functionName]!();
            messages.add(
              Message(role: MessageRole.tool, content: result.toString()),
            );
          }
        }
      } else {
        return response.message.content;
      }
    }
  }

  MessageRole _parseRole(String role) {
    return switch (role) {
      'user' => MessageRole.user,
      'assistant' => MessageRole.assistant,
      'system' => MessageRole.system,
      'tool' => MessageRole.tool,
      _ => MessageRole.user,
    };
  }
}
