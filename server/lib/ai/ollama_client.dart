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

  String _buildSystemPrompt(String? courseHistory) {
    String systemPrompt =
        'You are a helpful academic advisor assistant that helps students with their class schedules. '
        'It is currently the Winter 2026 term. ';

    // Insert user's graduation requirements
    systemPrompt +=
        '\n\nThe student needs to take the following courses to fulfill their graduation requirements:\n'
        '${AiTools.getUserGraduationRequirements()}\n\n';

    // Insert user's course history
    if (courseHistory == null || courseHistory.isEmpty) {
      return '$systemPrompt\n\n'
          'The student has not uploaded their class transcript. '
          'You will not have specific information about their course history, but you can still provide general advice.';
    }
    return '$systemPrompt\n\n'
        'The student has uploaded their class transcript. '
        'Here is their course history:\n'
        '$courseHistory\n\n'
        'Use this transcript data to understand what classes they have already taken and what requirements they may have fulfilled.';
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

    print('[DEBUG] Starting chat with ${messages.length} initial messages');
    print('[DEBUG] System message: ${messages.first.content}');

    while (true) {
      print('[DEBUG] Requesting chat completion from model: $model');
      final response = await client.generateChatCompletion(
        request: GenerateChatCompletionRequest(
          model: model,
          messages: messages,
          // tools: tools,
          options: RequestOptions(numPredict: -1),
        ),
      );

      print(
        '[DEBUG] Received response with ${response.message.toolCalls?.length ?? 0} tool calls',
      );
      messages.add(response.message);

      if (response.message.toolCalls != null &&
          response.message.toolCalls!.isNotEmpty) {
        print(
          '[DEBUG] Processing ${response.message.toolCalls!.length} tool call(s)',
        );
        for (final toolCall in response.message.toolCalls!) {
          final functionName = toolCall.function?.name;
          print('[DEBUG] Tool call: $functionName');
          if (functionName != null &&
              availableFunctions.containsKey(functionName)) {
            print('[DEBUG] Executing function: $functionName');
            final result = availableFunctions[functionName]!();
            messages.add(
              Message(role: MessageRole.tool, content: result.toString()),
            );
          } else {
            print('[DEBUG] Function not found or invalid: $functionName');
          }
        }
      } else {
        print('[DEBUG] No tool calls, returning final response');
        print('[DEBUG] Response content: ${response.message.content}');
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
