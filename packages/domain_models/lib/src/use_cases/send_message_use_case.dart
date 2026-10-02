import '../entities/message.dart';
import '../repositories/i_chat_repository.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/message_content.dart';

class SendMessageUseCase {
  final IChatRepository _chatRepository;

  const SendMessageUseCase(this._chatRepository);

  Future<Message> execute({
    required ConversationId conversationId,
    required UserId recipientId,
    required String text,
    List<String> attachments = const [],
  }) async {
    final content = MessageContent.create(
      text: text,
      attachments: attachments,
    );

    return await _chatRepository.sendMessage(
      conversationId: conversationId,
      recipientId: recipientId,
      content: content,
    );
  }
}
