import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';

void main() {
  group('Conversation Aggregate Root', () {
    final userA = UserId('user_a');
    final userB = UserId('user_b');
    final convId = ConversationId('conv_1');
    final now = DateTime.now().toUtc();

    test('successfully instantiates 1-on-1 conversation with two distinct users', () {
      final conversation = Conversation(
        id: convId,
        user1Id: userA,
        user2Id: userB,
        createdAt: now,
        updatedAt: now,
      );

      expect(conversation.isParticipant(userA), isTrue);
      expect(conversation.isParticipant(userB), isTrue);
      expect(conversation.getOtherParticipant(userA), equals(userB));
      expect(conversation.getOtherParticipant(userB), equals(userA));
    });

    test('throws DomainInvariantViolationException when user1 and user2 are identical', () {
      expect(
        () => Conversation(
          id: convId,
          user1Id: userA,
          user2Id: userA,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<DomainInvariantViolationException>()),
      );
    });

    test('throws UnauthorizedDomainActionException when requesting other participant for non-member', () {
      final conversation = Conversation(
        id: convId,
        user1Id: userA,
        user2Id: userB,
        createdAt: now,
        updatedAt: now,
      );

      expect(
        () => conversation.getOtherParticipant(UserId('intruder')),
        throwsA(isA<UnauthorizedDomainActionException>()),
      );
    });

    test('updates last message and handles unread count correctly', () {
      final conversation = Conversation(
        id: convId,
        user1Id: userA,
        user2Id: userB,
        createdAt: now,
        updatedAt: now,
      );

      final message = Message(
        id: MessageId('msg_1'),
        conversationId: convId,
        senderId: userA,
        recipientId: userB,
        content: MessageContent.create(text: 'Hello'),
        status: MessageStatus.sent,
        sentAt: now,
      );

      final updated = conversation.withLastMessage(message, incrementUnread: true);
      expect(updated.lastMessage, equals(message));
      expect(updated.unreadCount, equals(1));

      final reset = updated.resetUnread();
      expect(reset.unreadCount, equals(0));
    });
  });
}
