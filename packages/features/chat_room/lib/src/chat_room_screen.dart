import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/chat_room_controller.dart';
import 'test_ids.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final ConversationId conversationId;
  final UserId currentUserId;
  final UserId partnerId;
  final String partnerName;
  final String? partnerAvatarUrl;
  final bool isPartnerOnline;
  final VoidCallback onBack;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatarUrl,
    this.isPartnerOnline = false,
    required this.onBack,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _inputController = TextEditingController();

  ChatRoomParams get _params => ChatRoomParams(
        conversationId: widget.conversationId,
        recipientId: widget.partnerId,
      );

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onSend() {
    final text = _inputController.text;
    if (text.trim().isNotEmpty) {
      ref
          .read(chatRoomControllerProvider(_params).notifier)
          .sendMessage(text);
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatRoomControllerProvider(_params));
    final theme = Theme.of(context);
    final messages = state.messages;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: ChatTappable(
          testId: const Key(ChatRoomTestIds.backButton),
          onTap: widget.onBack,
          child: const Padding(
            padding: EdgeInsets.all(ChatSpacing.small),
            child: ChatIcon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            ChatAvatar(
              displayName: widget.partnerName,
              avatarUrl: widget.partnerAvatarUrl,
              isOnline: widget.isPartnerOnline,
              size: 40,
            ),
            const SizedBox(width: ChatSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatText(
                    widget.partnerName,
                    variant: ChatTextVariant.titleMedium,
                  ),
                  ChatText(
                    context.tr(
                      widget.isPartnerOnline
                          ? 'chat.status_online'
                          : 'chat.status_offline',
                    ),
                    variant: ChatTextVariant.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChatSpacing.medium,
                  vertical: ChatSpacing.small,
                ),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // reverse order so newest is at the bottom
                  final message = messages[messages.length - 1 - index];
                  final isOutgoing = message.senderId == widget.currentUserId;

                  return KeyedSubtree(
                    key: Key(ChatRoomTestIds.messageItem(message.id.value)),
                    child: ChatBubble(
                      message: message,
                      isOutgoing: isOutgoing,
                    ),
                  );
                },
              ),
            ),
            if (state.isPartnerTyping)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChatSpacing.medium,
                  vertical: ChatSpacing.xSmall,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: KeyedSubtree(
                    key: const Key(ChatRoomTestIds.typingIndicator),
                    child: ChatText(
                      context.tr('chat.typing'),
                      variant: ChatTextVariant.bodySmall,
                    ),
                  ),
                ),
              ),
            _MessageInputBar(
              controller: _inputController,
              onSend: _onSend,
              onChanged: (text) {
                ref
                    .read(chatRoomControllerProvider(_params)
                        .notifier)
                    .setTyping(text.trim().isNotEmpty);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;

  const _MessageInputBar({
    required this.controller,
    required this.onSend,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatSpacing.medium,
        vertical: ChatSpacing.small,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key(ChatRoomTestIds.messageInput),
              controller: controller,
              onChanged: onChanged,
              maxLines: null,
              decoration: InputDecoration(
                hintText: context.tr('chat.message_input_placeholder'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: ChatSpacing.medium,
                  vertical: ChatSpacing.small,
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
              ),
            ),
          ),
          const SizedBox(width: ChatSpacing.small),
          ChatTappable(
            testId: const Key(ChatRoomTestIds.sendButton),
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: ChatIcon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
