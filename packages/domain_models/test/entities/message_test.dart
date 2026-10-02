import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';

void main() {
  group('Message Entity', () {
    final senderId = UserId('sender_1');
    final recipientId = UserId('recipient_2');
    final convId = ConversationId('conv_1');
    final msgId = MessageId('msg_1');
    final sentTime = DateTime.parse('2026-10-01T12:00:00Z');

    test('transitions from sending/sent to delivered and read', () {
      final message = Message(
        id: msgId,
        conversationId: convId,
        senderId: senderId,
        recipientId: recipientId,
        content: MessageContent.create(text: 'How are you?'),
        status: MessageStatus.sent,
        sentAt: sentTime,
      );

      final deliveryTime = DateTime.parse('2026-10-01T12:00:05Z');
      final delivered = message.markDelivered(deliveryTime);

      expect(delivered.status, equals(MessageStatus.delivered));
      expect(delivered.deliveredAt, equals(deliveryTime));
      expect(delivered.readAt, isNull);

      final readTime = DateTime.parse('2026-10-01T12:01:00Z');
      final read = delivered.markRead(readTime);

      expect(read.status, equals(MessageStatus.read));
      expect(read.readAt, equals(readTime));
      expect(read.deliveredAt, equals(deliveryTime));
    });
  });
}
