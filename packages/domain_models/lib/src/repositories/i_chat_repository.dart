import '../entities/conversation.dart';
import '../entities/message.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/message_content.dart';

abstract class IChatRepository {
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessages(ConversationId conversationId);
  Future<Conversation> getOrCreateConversation(UserId recipientId);
  Future<Message> sendMessage({
    required ConversationId conversationId,
    required UserId recipientId,
    required MessageContent content,
  });
  Future<void> markMessageDelivered(MessageId messageId);
  Future<void> markMessageRead(MessageId messageId);
  Future<void> setTypingStatus({
    required ConversationId conversationId,
    required bool isTyping,
  });
}
