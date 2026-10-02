import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';

void main() {
  group('MessageContent Value Object', () {
    test('successfully creates valid text message content', () {
      final content = MessageContent.create(text: ' Hello, world! ');
      expect(content.text, equals('Hello, world!'));
      expect(content.attachments, isEmpty);
    });

    test('throws InvalidMessageContentException when text and attachments are empty', () {
      expect(
        () => MessageContent.create(text: '   '),
        throwsA(isA<InvalidMessageContentException>()),
      );
    });

    test('allows empty text if attachments are provided', () {
      final content = MessageContent.create(
        text: '',
        attachments: ['https://example.com/image.png'],
      );
      expect(content.text, isEmpty);
      expect(content.attachments.length, equals(1));
    });

    test('throws InvalidMessageContentException when text exceeds 5000 chars', () {
      final longText = 'a' * 5001;
      expect(
        () => MessageContent.create(text: longText),
        throwsA(isA<InvalidMessageContentException>()),
      );
    });

    test('supports value equality', () {
      final c1 = MessageContent.create(text: 'Test', attachments: ['url1']);
      final c2 = MessageContent.create(text: 'Test', attachments: ['url1']);
      expect(c1, equals(c2));
    });
  });
}
