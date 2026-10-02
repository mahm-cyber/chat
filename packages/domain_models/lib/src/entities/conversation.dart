import 'package:equatable/equatable.dart';
import '../exceptions/domain_exception.dart';
import '../value_objects/identifiers.dart';
import 'message.dart';

class Conversation extends Equatable {
  final ConversationId id;
  final UserId user1Id;
  final UserId user2Id;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (user1Id == user2Id) {
      throw const DomainInvariantViolationException(
        'A 1-on-1 conversation cannot be established with the same user as both participants.',
      );
    }
    if (unreadCount < 0) {
      throw const DomainInvariantViolationException(
        'Unread count cannot be negative.',
      );
    }
  }

  bool isParticipant(UserId userId) {
    return user1Id == userId || user2Id == userId;
  }

  UserId getOtherParticipant(UserId currentUserId) {
    if (user1Id == currentUserId) return user2Id;
    if (user2Id == currentUserId) return user1Id;
    throw UnauthorizedDomainActionException(
      'User "$currentUserId" is not a participant in conversation "$id".',
    );
  }

  Conversation withLastMessage(Message message, {bool incrementUnread = false}) {
    if (!isParticipant(message.senderId) || !isParticipant(message.recipientId)) {
      throw const DomainInvariantViolationException(
        'Message participants do not match conversation participants.',
      );
    }

    return Conversation(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      lastMessage: message,
      unreadCount: incrementUnread ? unreadCount + 1 : unreadCount,
      createdAt: createdAt,
      updatedAt: message.sentAt,
    );
  }

  Conversation resetUnread() {
    if (unreadCount == 0) return this;
    return Conversation(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      lastMessage: lastMessage,
      unreadCount: 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        lastMessage,
        unreadCount,
        createdAt,
        updatedAt,
      ];
}
