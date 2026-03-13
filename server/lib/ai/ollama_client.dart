import 'package:ollama_dart/ollama_dart.dart';
import 'package:server/ai/ai_tools.dart';
import 'package:server/ai/schedule_data.dart';

/// Client wrapper for interacting with the Ollama LLM server.
class AiChatClient {
  AiChatClient({
    this.baseUrl = 'http://ollama.cs.wallawalla.edu:11434/api',
    this.model = 'qwen3',
  });

  final String baseUrl;
  final String model;

  static const String _baseSystemPrompt =
      'You are a helpful academic advisor assistant at Walla Walla University '
      'that helps students plan their class schedules. ';

  String _buildSystemPrompt(String? courseHistory) {
    final buffer = StringBuffer(_baseSystemPrompt);

    // Add schedule/bulletin context summary.
    buffer.writeln();
    buffer.writeln(ScheduleData().contextSummary);
    buffer.writeln();
    buffer.writeln(
      'You have access to tools that let you look up:\n'
      '- The live class schedule (what classes are offered each quarter, '
      'with instructors, times, rooms, and enrollment status)\n'
      '- The university bulletin catalog (course descriptions and '
      'prerequisites)\n'
      '- The student\'s graduation requirements for CS BS\n'
      '- The list of all subject codes\n\n'
      'Use these tools proactively when the student asks about scheduling, '
      'prerequisites, or what courses to take next. '
      'When suggesting courses, always verify they are actually being '
      'offered in the target quarter by calling getClassesForQuarter.',
    );

    if (courseHistory == null || courseHistory.isEmpty) {
      buffer.writeln();
      buffer.writeln(
        'The student has not uploaded their class transcript. '
        'You will not have specific information about their course history, '
        'but you can still provide general advice.',
      );
    } else {
      buffer.writeln();
      buffer.writeln(
        'The student has uploaded their class transcript. '
        'Here is their course history:\n'
        '$courseHistory\n\n'
        'Use this transcript data to understand what classes '
        'they have already taken and what requirements they may have '
        'fulfilled.',
      );
    }

    return buffer.toString();
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
          final arguments = toolCall.function?.arguments ?? {};
          if (functionName != null &&
              availableFunctions.containsKey(functionName)) {
            final result = availableFunctions[functionName]!(arguments);
            messages.add(
              Message(role: MessageRole.tool, content: result),
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
