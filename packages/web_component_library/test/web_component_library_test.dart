import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';
import 'package:web_component_library/web_component_library.dart';

void main() {
  group('Web Component Library', () {
    test('TailwindTokens defines core theme tokens', () {
      expect(TailwindTokens.accentIndigo, contains('bg-indigo-600'));
      expect(TailwindTokens.bubbleOutgoing, contains('bg-indigo-600'));
      expect(TailwindTokens.bubbleIncoming, contains('bg-slate-200'));
    });

    test('ChatText creates component with testId and variant', () {
      const widget = ChatText.titleLarge('Hello Jaspr', testId: 'title_1');
      expect(widget.content, equals('Hello Jaspr'));
      expect(widget.testId, equals('title_1'));
      expect(widget.variant, equals(WebChatTextVariant.titleLarge));
    });

    test('ChatTappable retains testId and child', () {
      const tappable = ChatTappable(
        testId: 'action_btn',
        child: ChatText('Click Me'),
      );
      expect(tappable.testId, equals('action_btn'));
    });

    test('ChatAvatar configures initials and online presence', () {
      const avatar = ChatAvatar(
        name: 'Jane Doe',
        isOnline: true,
        showOnlineIndicator: true,
        testId: 'user_avatar',
      );
      expect(avatar.name, equals('Jane Doe'));
      expect(avatar.isOnline, isTrue);
      expect(avatar.testId, equals('user_avatar'));
    });

    test('ChatBubble configures outgoing and incoming message state', () {
      final msg = Message(
        id: MessageId('m1'),
        conversationId: ConversationId('c1'),
        senderId: UserId('u1'),
        recipientId: UserId('u2'),
        content: MessageContent.create(text: 'Web message content'),
        status: MessageStatus.delivered,
        sentAt: DateTime(2026, 1, 1, 10, 0),
      );

      final bubble = ChatBubble(
        message: msg,
        isOutgoing: true,
        testId: 'bubble_m1',
      );

      expect(bubble.message.content.text, equals('Web message content'));
      expect(bubble.isOutgoing, isTrue);
      expect(bubble.testId, equals('bubble_m1'));
    });
  });
}
