import '../entities/message.dart';
import '../repositories/i_chat_repository.dart';
import '../value_objects/identifiers.dart';

class WatchMessagesUseCase {
  final IChatRepository _chatRepository;

  const WatchMessagesUseCase(this._chatRepository);

  Stream<List<Message>> execute(ConversationId conversationId) {
    return _chatRepository.watchMessages(conversationId);
  }
}
