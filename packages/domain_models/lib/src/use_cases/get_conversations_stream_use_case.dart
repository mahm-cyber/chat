import '../entities/conversation.dart';
import '../repositories/i_chat_repository.dart';

class GetConversationsStreamUseCase {
  final IChatRepository _chatRepository;

  const GetConversationsStreamUseCase(this._chatRepository);

  Stream<List<Conversation>> execute() {
    return _chatRepository.watchConversations();
  }
}
