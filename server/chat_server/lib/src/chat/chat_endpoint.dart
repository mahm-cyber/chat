import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  /// Fetches an existing 1-on-1 conversation or creates a new one
  Future<ConversationModel> getOrCreateConversation(
    Session session, {
    required int currentUserId,
    required int recipientId,
  }) async {
    final u1 = currentUserId < recipientId ? currentUserId : recipientId;
    final u2 = currentUserId < recipientId ? recipientId : currentUserId;

    var conversation = await ConversationModel.db.findFirstRow(
      session,
      where: (t) => t.user1Id.equals(u1) & t.user2Id.equals(u2),
    );

    if (conversation == null) {
      final now = DateTime.now().toUtc();
      conversation = ConversationModel(
        user1Id: u1,
        user2Id: u2,
        unreadCountUser1: 0,
        unreadCountUser2: 0,
        createdAt: now,
        updatedAt: now,
      );
      conversation = await ConversationModel.db.insertRow(session, conversation);
    }

    return conversation;
  }

  /// Lists all conversations where the user is a participant
  Future<List<ConversationModel>> getConversations(
    Session session,
    int userId,
  ) async {
    return await ConversationModel.db.find(
      session,
      where: (t) => t.user1Id.equals(userId) | t.user2Id.equals(userId),
      orderByList: (t) => [t.updatedAt.desc()],
    );
  }

  /// Fetches historical messages for a given conversation
  Future<List<MessageModel>> getMessages(
    Session session, {
    required int conversationId,
    int? limit,
  }) async {
    return await MessageModel.db.find(
      session,
      where: (t) => t.conversationId.equals(conversationId),
      orderByList: (t) => [t.sentAt.asc()],
      limit: limit ?? 50,
    );
  }

  /// Sends a message and broadcasts it in real-time over the conversation channel
  Future<MessageModel> sendMessage(
    Session session, {
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
  }) async {
    final now = DateTime.now().toUtc();

    var message = MessageModel(
      conversationId: conversationId,
      senderId: senderId,
      recipientId: recipientId,
      content: content,
      attachmentUrls: attachmentUrls,
      status: 'sent',
      sentAt: now,
    );

    message = await MessageModel.db.insertRow(session, message);

    // Update conversation last message preview
    final conversation = await ConversationModel.db.findById(session, conversationId);
    if (conversation != null) {
      conversation.lastMessageText = content;
      conversation.lastMessageSentAt = now;
      conversation.updatedAt = now;
      if (conversation.user1Id == recipientId) {
        conversation.unreadCountUser1 += 1;
      } else {
        conversation.unreadCountUser2 += 1;
      }
      await ConversationModel.db.updateRow(session, conversation);
    }

    // Broadcast over WebSocket message bus
    final event = ChatEvent(
      type: 'message',
      conversationId: conversationId,
      senderId: senderId,
      message: message,
      timestamp: now,
    );
    await session.messages.postMessage('conversation_$conversationId', event);

    return message;
  }

  /// Marks a message as delivered
  Future<void> markMessageDelivered(
    Session session, {
    required int messageId,
    required int conversationId,
    required int senderId,
  }) async {
    final message = await MessageModel.db.findById(session, messageId);
    if (message != null && message.status != 'read') {
      final now = DateTime.now().toUtc();
      message.status = 'delivered';
      message.deliveredAt = now;
      await MessageModel.db.updateRow(session, message);

      final event = ChatEvent(
        type: 'delivered',
        conversationId: conversationId,
        senderId: senderId,
        messageId: messageId,
        timestamp: now,
      );
      await session.messages.postMessage('conversation_$conversationId', event);
    }
  }

  /// Marks a message as read
  Future<void> markMessageRead(
    Session session, {
    required int messageId,
    required int conversationId,
    required int senderId,
  }) async {
    final message = await MessageModel.db.findById(session, messageId);
    if (message != null) {
      final now = DateTime.now().toUtc();
      message.status = 'read';
      message.readAt = now;
      message.deliveredAt ??= now;
      await MessageModel.db.updateRow(session, message);

      final event = ChatEvent(
        type: 'read',
        conversationId: conversationId,
        senderId: senderId,
        messageId: messageId,
        timestamp: now,
      );
      await session.messages.postMessage('conversation_$conversationId', event);
    }
  }

  /// Broadcasts typing indicator event
  Future<void> sendTypingEvent(
    Session session, {
    required int conversationId,
    required int senderId,
    required bool isTyping,
  }) async {
    final event = ChatEvent(
      type: 'typing',
      conversationId: conversationId,
      senderId: senderId,
      isTyping: isTyping,
      timestamp: DateTime.now().toUtc(),
    );
    await session.messages.postMessage('conversation_$conversationId', event);
  }

  /// Real-time stream of incoming messages, delivery updates, and typing events
  Stream<ChatEvent> watchConversation(
    Session session,
    int conversationId,
  ) async* {
    final stream = session.messages.createStream<ChatEvent>('conversation_$conversationId');
    yield* stream;
  }
}
