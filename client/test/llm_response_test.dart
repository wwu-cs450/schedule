import 'package:client/domain/models/llm_response.dart';
import 'package:flutter_test/flutter_test.dart';
import '_data/test_data.dart';

void main() {
  group('LLMResponse.parse', () {
    test(
      'should parse think tags and main message from sampleLLMResponseText',
      () {
        final result = LLMResponse.parse(sampleLLMResponseText);

        // Think content should contain the reasoning
        expect(result.think!.isNotEmpty, true);
        expect(
          result.think,
          contains("Okay, let me process the user's question"),
        );
        expect(
          result.think,
          isNot(contains("Let me know if you'd like help interpreting these!")),
        );

        // Main message should not contain think tags
        expect(result.mainMessage.isNotEmpty, true);
        expect(
          result.mainMessage,
          contains("Here are the classes you're registered for"),
        );
        expect(result.mainMessage, contains('**Winter 2026:**'));
        expect(result.mainMessage, contains('CPTR 308'));
        expect(result.mainMessage, isNot(contains('<think>')));
        expect(result.mainMessage, isNot(contains('</think>')));
        expect(result.mainMessage, isNot(contains('Okay, let me process')));
      },
    );

    test('should handle message without think tags', () {
      const message = 'This is a simple message without think tags.';
      final result = LLMResponse.parse(message);

      expect(result.think, isNull);
      expect(
        result.mainMessage,
        equals('This is a simple message without think tags.'),
      );
    });

    test('should handle multiple think blocks', () {
      const message = '''
<think>First thought</think>
Some content here.
<think>Second thought</think>
More content.
''';
      final result = LLMResponse.parse(message);

      expect(result.think, contains('First thought'));
      expect(result.think, contains('Second thought'));
      expect(result.mainMessage, contains('Some content here.'));
      expect(result.mainMessage, contains('More content.'));
      expect(result.mainMessage, isNot(contains('<think>')));
    });

    test('should handle empty think tags', () {
      const message = '<think></think>Hello world';
      final result = LLMResponse.parse(message);

      expect(result.think, isNull);
      expect(result.mainMessage, equals('Hello world'));
    });
  });
}
