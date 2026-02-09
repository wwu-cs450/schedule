import 'package:ollama_dart/ollama_dart.dart';
import 'package:server/ai_tools.dart';

/// Client wrapper for interacting with the Ollama LLM server.
class AiChatClient {
  AiChatClient({
    this.baseUrl = 'http://ollama.cs.wallawalla.edu:11434/api',
    this.model = 'qwen3',
  });

  final String baseUrl;
  final String model;

  Future<String> chat(List<Map<String, String>> conversationHistory) async {
    final client = OllamaClient(baseUrl: baseUrl);

    // Convert the incoming conversation history to Ollama Message objects.
    final messages = <Message>[
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
