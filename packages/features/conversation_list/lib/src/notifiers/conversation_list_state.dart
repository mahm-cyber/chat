import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class ConversationListState extends Equatable {
  final List<Conversation> conversations;
  final String searchQuery;
  final bool isLoading;

  const ConversationListState({
    this.conversations = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<Conversation> filteredConversations(UserId currentUserId) {
    if (searchQuery.trim().isEmpty) return conversations;
    final query = searchQuery.trim().toLowerCase();
    return conversations.where((c) {
      final other = c.otherParticipant(currentUserId);
      return other.displayName.toLowerCase().contains(query) ||
          (c.lastMessage?.content.text.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  ConversationListState copyWith({
    List<Conversation>? conversations,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ConversationListState(
      conversations: conversations ?? this.conversations,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [conversations, searchQuery, isLoading];
}
