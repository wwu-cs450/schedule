import 'package:ai_server/ai_tools.dart';
import 'package:ollama_dart/ollama_dart.dart';

void main() async {
  final client = OllamaClient(
    baseUrl: "http://ollama.cs.wallawalla.edu:11434/api",
  );

  final messages = <Message>[
    Message(
      role: MessageRole.user,
      content: 'What classes am I taking this quarter?',
    ),
  ];

  while (true) {
    final response = await client.generateChatCompletion(
      request: GenerateChatCompletionRequest(
        model: 'qwen3', // smaller model is qwen3:0.6b
        messages: messages,
        tools: tools,
        options: RequestOptions(numPredict: -1),
      ),
    );

    messages.add(response.message);

    print('Thinking: ${response.message.thinking ?? 'N/A'}');
    print('Content: ${response.message.content}');

    if (response.message.toolCalls != null &&
        response.message.toolCalls!.isNotEmpty) {
      for (final toolCall in response.message.toolCalls!) {
        final functionName = toolCall.function?.name;
        if (functionName != null &&
            availableFunctions.containsKey(functionName)) {
          final args = toolCall.function?.arguments;
          print('Calling $functionName with arguments $args');

          final result = availableFunctions[functionName]!();

          print('Result: $result');

          // Add the tool result to the messages
          messages.add(
            Message(role: MessageRole.tool, content: result.toString()),
          );
        }
      }
    } else {
      // End the loop when there are no more tool calls
      break;
    }
  }
}
