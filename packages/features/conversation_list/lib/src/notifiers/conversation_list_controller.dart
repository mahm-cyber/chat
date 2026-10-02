import 'dart:async';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'conversation_list_state.dart';

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  throw UnimplementedError('chatRepositoryProvider must be overridden');
});

final currentUserIdProvider = Provider<UserId>((ref) {
  throw UnimplementedError('currentUserIdProvider must be overridden');
});

final conversationListControllerProvider = StateNotifierProvider.autoDispose<
    ConversationListController, ConversationListState>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ConversationListController(chatRepository: chatRepository);
});

class ConversationListController extends StateNotifier<ConversationListState> {
  final IChatRepository chatRepository;
  StreamSubscription<List<Conversation>>? _subscription;

  ConversationListController({required this.chatRepository})
      : super(const ConversationListState(isLoading: true)) {
    _init();
  }

  void _init() {
    _subscription = chatRepository.watchConversations().listen((conversations) {
      state = state.copyWith(
        conversations: conversations,
        isLoading: false,
      );
    });
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
