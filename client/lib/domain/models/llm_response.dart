class LLMResponse {
  LLMResponse({required this.mainMessage, this.think});

  /// Parses the raw response from the LLM, separating out any `<think>...<think>` content from the main message.
  factory LLMResponse.parse(String message) {
    final thinkRegex = RegExp('<think>(.*?)</think>', dotAll: true);
    final matches = thinkRegex.allMatches(message);

    // Extract all think content
    final thinkParts = <String>[];
    for (final match in matches) {
      final content = match.group(1)?.trim() ?? '';
      if (content.isNotEmpty) {
        thinkParts.add(content);
      }
    }

    // Remove all <think> tags and their content to get the main message
    final mainMessage = message.replaceAll(thinkRegex, '').trim();

    // Combine all think parts with newlines
    final think = thinkParts.join('\n\n');

    if (think.isEmpty) {
      return LLMResponse(mainMessage: mainMessage);
    } else {
      return LLMResponse(think: think, mainMessage: mainMessage);
    }
  }

  final String? think;
  final String mainMessage;
}
