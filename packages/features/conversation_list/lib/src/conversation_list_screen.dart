import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/conversation_list_controller.dart';
import 'test_ids.dart';

class ConversationListScreen extends ConsumerWidget {
  final void Function(ConversationId conversationId) onSelectConversation;
  final VoidCallback onNewChat;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;

  const ConversationListScreen({
    super.key,
    required this.onSelectConversation,
    required this.onNewChat,
    required this.onOpenProfile,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationListControllerProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    final theme = Theme.of(context);
    final conversations = state.filteredConversations(currentUserId);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: ChatText(
          context.tr('chat.conversations_title'),
          variant: ChatTextVariant.titleLarge,
        ),
        centerTitle: false,
        actions: [
          ChatTappable(
            testId: const Key(ConversationListTestIds.profileButton),
            onTap: onOpenProfile,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: ChatSpacing.small),
              child: ChatIcon(Icons.person_outline_rounded, size: 24),
            ),
          ),
          ChatTappable(
            testId: const Key(ConversationListTestIds.settingsButton),
            onTap: onOpenSettings,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: ChatSpacing.small),
              child: ChatIcon(Icons.settings_outlined, size: 24),
            ),
          ),
          const SizedBox(width: ChatSpacing.xSmall),
        ],
      ),
      floatingActionButton: ChatTappable(
        testId: const Key(ConversationListTestIds.newChatButton),
        onTap: onNewChat,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: ChatIcon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(ChatSpacing.medium),
              child: _SearchBar(
                onChanged: (val) {
                  ref
                      .read(conversationListControllerProvider.notifier)
                      .setSearchQuery(val);
                },
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : conversations.isEmpty
                      ? const _EmptyConversationsView()
                      : ListView.separated(
                          itemCount: conversations.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 72,
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];
                            final other =
                                conversation.otherParticipant(currentUserId);
                            return _ConversationItemTile(
                              conversation: conversation,
                              otherParticipant: other,
                              onTap: () => onSelectConversation(conversation.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      key: const Key(ConversationListTestIds.searchInput),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: context.tr('chat.search_placeholder'),
        filled: true,
        fillColor: theme.colorScheme.surface,
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: ChatSpacing.small),
          child: ChatIcon(Icons.search_rounded, size: 20),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.medium,
          vertical: ChatSpacing.small,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
      ),
    );
  }
}

class _EmptyConversationsView extends StatelessWidget {
  const _EmptyConversationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      key: const Key(ConversationListTestIds.emptyView),
      child: Padding(
        padding: const EdgeInsets.all(ChatSpacing.xLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChatIcon(
              Icons.forum_outlined,
              size: 64,
              color: theme.disabledColor,
            ),
            const SizedBox(height: ChatSpacing.medium),
            ChatText(
              context.tr('chat.empty_conversations'),
              variant: ChatTextVariant.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationItemTile extends StatelessWidget {
  final Conversation conversation;
  final User otherParticipant;
  final VoidCallback onTap;

  const _ConversationItemTile({
    required this.conversation,
    required this.otherParticipant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastText = conversation.lastMessage?.content.text ?? '';
    final unread = conversation.unreadCount;

    return ChatTappable(
      testId: Key(ConversationListTestIds.conversationItem(conversation.id.value)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ChatSpacing.medium,
          vertical: ChatSpacing.small,
        ),
        child: Row(
          children: [
            ChatAvatar(
              displayName: otherParticipant.displayName,
              avatarUrl: otherParticipant.avatarUrl,
              isOnline: otherParticipant.isOnline,
              size: 52,
            ),
            const SizedBox(width: ChatSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatText(
                    otherParticipant.displayName,
                    variant: ChatTextVariant.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  ChatText(
                    lastText,
                    variant: ChatTextVariant.bodySmall,
                  ),
                ],
              ),
            ),
            if (unread > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: ChatText(
                  unread.toString(),
                  variant: ChatTextVariant.labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
