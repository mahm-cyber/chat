import 'package:domain_models/domain_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web_component_library/web_component_library.dart';

import '../localization.dart';

class WebSidebar extends StatelessComponent {
  final List<Conversation> conversations;
  final Conversation? selectedConversation;
  final ValueChanged<Conversation> onSelectConversation;
  final VoidCallback onNewChat;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String currentUserName;

  const WebSidebar({
    required this.conversations,
    required this.selectedConversation,
    required this.onSelectConversation,
    required this.onNewChat,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.currentUserName,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'w-full md:w-80 lg:w-96 h-full flex flex-col border-r border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900',
      [
        // Header
        div(
          classes:
              'p-4 flex items-center justify-between border-b border-slate-100 dark:border-slate-800',
          [
            div(classes: 'flex items-center gap-3', [
              ChatAvatar(name: currentUserName, size: 36),
              ChatText.titleLarge(
                localize('conversations.title'),
                className: 'text-lg font-bold',
              ),
            ]),
            div(classes: 'flex items-center gap-2', [
              ChatTappable(
                testId: 'theme_toggle_button',
                className:
                    'p-2 rounded-lg text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800 hover:text-slate-700 dark:hover:text-slate-300 transition-colors',
                onClick: onToggleTheme,
                child: isDarkMode
                    ? const ChatIcon(WebChatIconType.sun, size: 20)
                    : const ChatIcon(WebChatIconType.moon, size: 20),
              ),
              ChatTappable(
                testId: 'web_new_chat_button',
                className:
                    'p-2 rounded-lg bg-indigo-600 hover:bg-indigo-700 text-white transition-colors',
                onClick: onNewChat,
                child: const ChatIcon(WebChatIconType.phone, size: 18),
              ),
            ]),
          ],
        ),

        // Search bar
        div(classes: 'p-3', [
          div(
            classes:
                'flex items-center gap-2 px-3 py-2 rounded-xl bg-slate-100 dark:bg-slate-800 border border-transparent focus-within:border-indigo-500 transition-all',
            [
              const ChatIcon.search(
                size: 16,
                className: 'text-slate-400 dark:text-slate-500',
              ),
              input(
                type: InputType.text,
                classes:
                    'w-full bg-transparent text-sm text-slate-900 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none',
                attributes: {
                  'placeholder': localize('conversations.search_hint'),
                  'data-testid': 'web_conversation_search_input',
                },
              ),
            ],
          ),
        ]),

        // Conversation List
        div(
          classes: 'flex-1 overflow-y-auto divide-y divide-slate-100 dark:divide-slate-800/60',
          [
            if (conversations.isEmpty)
              div(
                classes: 'p-8 text-center text-slate-400 dark:text-slate-500',
                [
                  ChatText.bodySmall(
                    localize('conversations.empty_state'),
                    className: 'text-center block',
                  ),
                ],
              )
            else
              for (final conv in conversations)
                _buildConversationItem(conv),
          ],
        ),
      ],
    );
  }

  Component _buildConversationItem(Conversation conv) {
    final isSelected = selectedConversation?.id == conv.id;
    final partner = conv.user2 ??
        User(
          id: UserId('partner'),
          phoneNumber: PhoneNumber.parse('+1000000000'),
          displayName: 'Chat Contact',
          createdAt: DateTime.now(),
        );

    final itemClasses = isSelected
        ? 'bg-indigo-50 dark:bg-indigo-950/40 border-l-4 border-indigo-600'
        : 'hover:bg-slate-50 dark:hover:bg-slate-800/40 border-l-4 border-transparent';

    return div(
      classes:
          'p-3 cursor-pointer transition-colors flex items-center gap-3 $itemClasses',
      attributes: {
        'data-testid': 'web_conversation_item_${conv.id.value}',
      },
      events: {
        'click': (_) => onSelectConversation(conv),
      },
      [
        ChatAvatar(
          name: partner.displayName,
          imageUrl: partner.photoUrl,
          size: 44,
          isOnline: partner.isOnline,
          showOnlineIndicator: true,
        ),
        div(classes: 'flex-1 min-w-0', [
          div(classes: 'flex items-center justify-between', [
            ChatText.titleSmall(
              partner.displayName,
              className: 'truncate font-medium',
            ),
            if (conv.lastMessage != null)
              ChatText.caption(
                '${conv.lastMessage!.sentAt.hour.toString().padLeft(2, '0')}:${conv.lastMessage!.sentAt.minute.toString().padLeft(2, '0')}',
              ),
          ]),
          div(classes: 'flex items-center justify-between mt-1', [
            ChatText.bodySmall(
              conv.lastMessage?.content.text ?? '',
              className: 'truncate text-slate-500 dark:text-slate-400 max-w-[200px]',
            ),
            if (conv.unreadCount > 0)
              span(
                classes:
                    'px-2 py-0.5 text-xs font-bold text-white bg-indigo-600 rounded-full',
                [Component.text(conv.unreadCount.toString())],
              ),
          ]),
        ]),
      ],
    );
  }
}
