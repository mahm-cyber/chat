import '../repositories/i_chat_repository.dart';
import '../value_objects/identifiers.dart';

class MarkMessageReadUseCase {
  final IChatRepository _chatRepository;

  const MarkMessageReadUseCase(this._chatRepository);

  Future<void> execute(MessageId messageId) {
    return _chatRepository.markMessageRead(messageId);
  }
}
