import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';

MessageStatus parseMessageStatus(String status) {
  switch (status.toLowerCase()) {
    case 'sending':
      return MessageStatus.sending;
    case 'delivered':
      return MessageStatus.delivered;
    case 'read':
      return MessageStatus.read;
    case 'failed':
      return MessageStatus.failed;
    case 'sent':
    default:
      return MessageStatus.sent;
  }
}

Message mapRemoteMessageToDomain(MessageModel model) {
  return Message(
    id: MessageId(model.id?.toString() ?? 'temp_${DateTime.now().millisecondsSinceEpoch}'),
    conversationId: ConversationId(model.conversationId.toString()),
    senderId: UserId(model.senderId.toString()),
    recipientId: UserId(model.recipientId.toString()),
    content: MessageContent.create(
      text: model.content,
      attachments: model.attachmentUrls ?? const [],
    ),
    status: parseMessageStatus(model.status),
    sentAt: model.sentAt,
    deliveredAt: model.deliveredAt,
    readAt: model.readAt,
  );
}

Conversation mapRemoteConversationToDomain(
  ConversationModel model, {
  required UserId currentUserId,
}) {
  final currentIdInt = int.tryParse(currentUserId.value);
  final unreadCount = (currentIdInt != null && currentIdInt == model.user1Id)
      ? model.unreadCountUser1
      : model.unreadCountUser2;

  Message? lastMsg;
  if (model.lastMessageText != null && model.lastMessageSentAt != null) {
    lastMsg = Message(
      id: MessageId('summary_${model.id}'),
      conversationId: ConversationId(model.id.toString()),
      senderId: UserId(model.user1Id.toString()),
      recipientId: UserId(model.user2Id.toString()),
      content: MessageContent.create(text: model.lastMessageText!),
      status: MessageStatus.sent,
      sentAt: model.lastMessageSentAt!,
    );
  }

  return Conversation(
    id: ConversationId(model.id.toString()),
    user1Id: UserId(model.user1Id.toString()),
    user2Id: UserId(model.user2Id.toString()),
    lastMessage: lastMsg,
    unreadCount: unreadCount,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );
}
