import 'package:equatable/equatable.dart';
import '../exceptions/domain_exception.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/phone_number.dart';
import 'message.dart';
import 'user.dart';

class Conversation extends Equatable {
  final ConversationId id;
  final UserId user1Id;
  final UserId user2Id;
  final User? user1;
  final User? user2;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    UserId? user1Id,
    UserId? user2Id,
    this.user1,
    this.user2,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
  })  : user1Id = user1Id ?? user1?.id ?? UserId('user_unknown_1'),
        user2Id = user2Id ?? user2?.id ?? UserId('user_unknown_2') {
    if (this.user1Id == this.user2Id) {
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

  User otherParticipant(UserId currentUserId) {
    if (user1 != null && user2 != null) {
      if (user1Id == currentUserId) return user2!;
      if (user2Id == currentUserId) return user1!;
    }
    final otherId = getOtherParticipant(currentUserId);
    return User(
      id: otherId,
      phoneNumber: PhoneNumber.parse('+10000000000'),
      displayName: 'User ${otherId.value}',
      createdAt: createdAt,
    );
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
