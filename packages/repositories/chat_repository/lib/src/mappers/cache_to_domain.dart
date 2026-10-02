import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'remote_to_domain.dart';

Message mapCacheMessageToDomain(MessageCM cm) {
  return Message(
    id: MessageId(cm.id),
    conversationId: ConversationId(cm.conversationId),
    senderId: UserId(cm.senderId),
    recipientId: UserId(cm.recipientId),
    content: MessageContent.create(
      text: cm.text,
      attachments: cm.attachments,
    ),
    status: parseMessageStatus(cm.status),
    sentAt: DateTime.parse(cm.sentAt),
    deliveredAt:
        cm.deliveredAt != null ? DateTime.tryParse(cm.deliveredAt!) : null,
    readAt: cm.readAt != null ? DateTime.tryParse(cm.readAt!) : null,
  );
}

Conversation mapCacheConversationToDomain(ConversationCM cm) {
  return Conversation(
    id: ConversationId(cm.id),
    user1Id: UserId(cm.user1Id),
    user2Id: UserId(cm.user2Id),
    lastMessage:
        cm.lastMessage != null ? mapCacheMessageToDomain(cm.lastMessage!) : null,
    unreadCount: cm.unreadCount,
    createdAt: DateTime.parse(cm.createdAt),
    updatedAt: DateTime.parse(cm.updatedAt),
  );
}
