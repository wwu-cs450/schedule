import 'package:ollama_dart/ollama_dart.dart';

/// Add two numbers
int add(int a, int b) {
  return a + b;
}

/// Multiply two numbers
int multiply(int a, int b) {
  return a * b;
}

void main() async {
  final client = OllamaClient(
    baseUrl: "http://ollama.cs.wallawalla.edu:11434/api",
  );

  final availableFunctions = {'add': add, 'multiply': multiply};

  final messages = <Message>[
    Message(role: MessageRole.user, content: 'What is (11434+12341)*412?'),
  ];

  while (true) {
    final response = await client.generateChatCompletion(
      request: GenerateChatCompletionRequest(
        model: 'qwen3:0.6b',
        messages: messages,
        tools: [
          Tool(
            type: ToolType.function,
            function: ToolFunction(
              name: 'add',
              description: 'Add two numbers. Use the tools provided.',
              parameters: {
                'type': 'object',
                'properties': {
                  'a': {'type': 'integer', 'description': 'The first number'},
                  'b': {'type': 'integer', 'description': 'The second number'},
                },
                'required': ['a', 'b'],
              },
            ),
          ),
          Tool(
            type: ToolType.function,
            function: ToolFunction(
              name: 'multiply',
              description: 'Multiply two numbers',
              parameters: {
                'type': 'object',
                'properties': {
                  'a': {'type': 'integer', 'description': 'The first number'},
                  'b': {'type': 'integer', 'description': 'The second number'},
                },
                'required': ['a', 'b'],
              },
            ),
          ),
        ],
        options: RequestOptions(
          // Note: The 'think' parameter may need to be set differently
          // depending on the ollama_dart package version
          numPredict: -1,
        ),
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

          final result = availableFunctions[functionName]!(
            args?['a'] as int,
            args?['b'] as int,
          );

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
