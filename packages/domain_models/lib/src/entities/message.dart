import 'package:equatable/equatable.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/message_content.dart';

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class Message extends Equatable {
  final MessageId id;
  final ConversationId conversationId;
  final UserId senderId;
  final UserId recipientId;
  final MessageContent content;
  final MessageStatus status;
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.status,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
  });

  Message markDelivered(DateTime timestamp) {
    if (status == MessageStatus.read) return this;
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      recipientId: recipientId,
      content: content,
      status: MessageStatus.delivered,
      sentAt: sentAt,
      deliveredAt: timestamp,
      readAt: readAt,
    );
  }

  Message markRead(DateTime timestamp) {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      recipientId: recipientId,
      content: content,
      status: MessageStatus.read,
      sentAt: sentAt,
      deliveredAt: deliveredAt ?? timestamp,
      readAt: timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        recipientId,
        content,
        status,
        sentAt,
        deliveredAt,
        readAt,
      ];
}
