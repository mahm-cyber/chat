import 'dart:async';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_room_state.dart';

class ChatRoomParams extends Equatable {
  final ConversationId conversationId;
  final UserId recipientId;

  const ChatRoomParams({
    required this.conversationId,
    required this.recipientId,
  });

  @override
  List<Object?> get props => [conversationId, recipientId];
}

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  throw UnimplementedError('chatRepositoryProvider must be overridden');
});

final currentUserIdProvider = Provider<UserId>((ref) {
  throw UnimplementedError('currentUserIdProvider must be overridden');
});

final chatRoomControllerProvider = StateNotifierProvider.autoDispose
    .family<ChatRoomController, ChatRoomState, ChatRoomParams>((ref, params) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return ChatRoomController(
    chatRepository: chatRepository,
    conversationId: params.conversationId,
    recipientId: params.recipientId,
    currentUserId: currentUserId,
  );
});

class ChatRoomController extends StateNotifier<ChatRoomState> {
  final IChatRepository chatRepository;
  final ConversationId conversationId;
  final UserId recipientId;
  final UserId currentUserId;
  StreamSubscription<List<Message>>? _messagesSub;

  ChatRoomController({
    required this.chatRepository,
    required this.conversationId,
    required this.recipientId,
    required this.currentUserId,
  }) : super(const ChatRoomState()) {
    _init();
  }

  void _init() {
    _messagesSub =
        chatRepository.watchMessages(conversationId).listen((messages) {
      state = state.copyWith(messages: messages);

      // Mark incoming unread messages as read
      for (final msg in messages) {
        if (msg.senderId != currentUserId && msg.status != MessageStatus.read) {
          chatRepository.markMessageRead(msg.id);
        }
      }
    });
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = state.copyWith(isSending: true, clearError: true);
    try {
      await chatRepository.sendMessage(
        conversationId: conversationId,
        recipientId: recipientId,
        content: MessageContent(text: trimmed),
      );
      state = state.copyWith(isSending: false);
    } catch (_) {
      state = state.copyWith(
        isSending: false,
        errorMessageKey: 'common.error',
      );
    }
  }

  void setTyping(bool isTyping) {
    chatRepository.setTypingStatus(
      conversationId: conversationId,
      isTyping: isTyping,
    );
  }

  @override
  void dispose() {
    _messagesSub?.cancel();
    super.dispose();
  }
}
