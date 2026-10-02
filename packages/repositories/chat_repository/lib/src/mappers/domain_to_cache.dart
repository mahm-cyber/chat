import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

MessageCM mapDomainMessageToCache(Message domain) {
  return MessageCM(
    id: domain.id.value,
    conversationId: domain.conversationId.value,
    senderId: domain.senderId.value,
    recipientId: domain.recipientId.value,
    text: domain.content.text,
    attachments: domain.content.attachments,
    status: domain.status.name,
    sentAt: domain.sentAt.toIso8601String(),
    deliveredAt: domain.deliveredAt?.toIso8601String(),
    readAt: domain.readAt?.toIso8601String(),
  );
}

ConversationCM mapDomainConversationToCache(Conversation domain) {
  return ConversationCM(
    id: domain.id.value,
    user1Id: domain.user1Id.value,
    user2Id: domain.user2Id.value,
    lastMessage: domain.lastMessage != null
        ? mapDomainMessageToCache(domain.lastMessage!)
        : null,
    unreadCount: domain.unreadCount,
    createdAt: domain.createdAt.toIso8601String(),
    updatedAt: domain.updatedAt.toIso8601String(),
  );
}
