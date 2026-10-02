import 'package:domain_models/domain_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web_component_library/web_component_library.dart';

import '../localization.dart';

class WebChatView extends StatelessComponent {
  final Conversation conversation;
  final List<Message> messages;
  final UserId currentUserId;
  final VoidCallback onBack;
  final ValueChanged<String> onSendMessage;
  final String inputText;
  final ValueChanged<String> onInputChanged;

  const WebChatView({
    required this.conversation,
    required this.messages,
    required this.currentUserId,
    required this.onBack,
    required this.onSendMessage,
    required this.inputText,
    required this.onInputChanged,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final partner = conversation.user2 ??
        User(
          id: UserId('partner'),
          phoneNumber: PhoneNumber.parse('+1000000000'),
          displayName: 'Chat Contact',
          createdAt: DateTime.now(),
        );

    return div(
      classes: 'flex-1 h-full flex flex-col bg-slate-50 dark:bg-slate-950',
      [
        // Chat Header
        div(
          classes:
              'h-16 px-4 flex items-center justify-between border-b border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md',
          [
            div(classes: 'flex items-center gap-3', [
              // Back button on mobile
              div(classes: 'md:hidden', [
                ChatTappable(
                  testId: 'web_back_button',
                  className: 'p-1.5 rounded-lg text-slate-500 hover:bg-slate-100',
                  onClick: onBack,
                  child: const ChatIcon(WebChatIconType.phone, size: 20),
                ),
              ]),
              ChatAvatar(
                name: partner.displayName,
                imageUrl: partner.photoUrl,
                size: 40,
                isOnline: partner.isOnline,
                showOnlineIndicator: true,
              ),
              div(classes: 'flex flex-col', [
                ChatText.titleMedium(
                  partner.displayName,
                  className: 'leading-tight font-semibold',
                ),
                ChatText.caption(
                  partner.isOnline ? 'Online' : 'Offline',
                  className: partner.isOnline
                      ? 'text-emerald-500 dark:text-emerald-400 font-medium'
                      : 'text-slate-400 dark:text-slate-500',
                ),
              ]),
            ]),
          ],
        ),

        // Message List
        div(
          classes:
              'flex-1 p-4 overflow-y-auto flex flex-col space-y-2',
          attributes: {
            'data-testid': 'web_message_list',
          },
          [
            if (messages.isEmpty)
              div(
                classes:
                    'm-auto text-center p-6 text-slate-400 dark:text-slate-500 max-w-sm',
                [
                  ChatText.bodySmall(
                    localize('conversations.empty_state'),
                    className: 'text-center block',
                  ),
                ],
              )
            else
              for (final message in messages)
                ChatBubble(
                  message: message,
                  isOutgoing: message.senderId == currentUserId,
                  testId: 'web_message_bubble_${message.id.value}',
                ),
          ],
        ),

        // Input Bar
        div(
          classes:
              'p-3 border-t border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900',
          [
            div(
              classes:
                  'flex items-center gap-2 max-w-4xl mx-auto bg-slate-100 dark:bg-slate-800/80 rounded-2xl px-4 py-2 border border-slate-200 dark:border-slate-700/60 focus-within:border-indigo-500 transition-all',
              [
                input(
                  type: InputType.text,
                  classes:
                      'flex-1 bg-transparent text-sm text-slate-900 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none py-1',
                  attributes: {
                    'placeholder': localize('chat.type_message'),
                    'value': inputText,
                    'data-testid': 'web_message_input',
                  },
                  events: {
                    'input': (e) {
                      final val = (e.target as dynamic).value as String? ?? '';
                      onInputChanged(val);
                    },
                    'keydown': (e) {
                      final key = (e as dynamic).key as String?;
                      if (key == 'Enter' && inputText.trim().isNotEmpty) {
                        onSendMessage(inputText);
                      }
                    },
                  },
                ),
                ChatTappable(
                  testId: 'web_send_button',
                  disabled: inputText.trim().isEmpty,
                  className:
                      'p-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed text-white transition-all shadow-sm',
                  onClick: () {
                    if (inputText.trim().isNotEmpty) {
                      onSendMessage(inputText);
                    }
                  },
                  child: const ChatIcon.send(size: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
