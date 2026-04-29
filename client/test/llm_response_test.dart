import 'package:client/domain/models/llm_response.dart';
import 'package:flutter_test/flutter_test.dart';

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

final sampleLLMResponseText = '''
<think>
Okay, let me process the user's question and the tool response. The user asked, "What classes am I taking this quarter?" The tool called was getUserRegisteredClasses, which returned a list of classes with terms like "Winter, 2026" and "Spring, 2026". 

First, I need to determine which classes are for the current quarter. The user mentioned "this quarter," which typically refers to the current term. However, the exact current term isn't specified in the user's query. The tool response includes classes for both Winter 2026 and Spring 2026. 

Assuming the current quarter is Winter 2026, the relevant classes would be those with the term "Winter, 2026". The Spring 2026 classes might be for a future quarter. But since the user asked about "this quarter," I should focus on the Winter term. However, if the current term is actually Spring 2026, then those classes would be the ones. 

But since the user didn't specify the exact term, maybe I should list all registered classes and mention the terms. Alternatively, check if there's a way to determine the current term. Since the tool response includes both terms, perhaps the user is enrolled in multiple terms. 

Wait, the user's question is about "this quarter," which is present tense. If the current date is, say, March 2023, then Winter 2026 would be in the future. But maybe the system's data is hypothetical. The user might be asking in a context where the current term is Winter 2026. 

Alternatively, the user might be confused about the terms. To be safe, I should list all the classes the user is registered for, noting the terms. That way, the user can see which are for the current quarter and which are for future ones. 

So, the response should include all the classes from the tool response, grouped by term. That way, the user can easily see which classes are for the current quarter (assuming Winter 2026 is the current term) and which are for future quarters. If the current term is different, the user can adjust accordingly. 

I need to present the information clearly, perhaps listing each class with course, title, credits, and term. Also, mention that the terms are Winter and Spring 2026, so the user can check which applies to their current quarter.
</think>

Here are the classes you're registered for, along with their terms:

**Winter 2026:**
- **CPTR 308** - Ethical Issues for Computing (4 credits)
- **CPTR 430** - Artificial Intelligence (4 credits)
- **CPTR 454** - Design & Analy of Algorithms (4 credits)
- **DRMA 101** - Introduction to Theatre (3 credits)
- **DRMA 252** - Performance (0 credits)
- **PEAC 164** - Downhill Skiing/Snowboarding (1 credit)

**Spring 2026:**
- **CPTR 352** - Operating Systems (4 credits)
- **MATH 315** - Probability & Statistics (4 credits)
- **RELT 202** - Christian Beliefs (4 credits)

Let me know if you'd like help interpreting these!
''';
