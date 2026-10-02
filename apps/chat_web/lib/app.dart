import 'package:domain_models/domain_models.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web_component_library/web_component_library.dart';

import 'src/components/chat_view.dart';
import 'src/components/sidebar.dart';
import 'src/localization.dart';

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDarkMode = true;
  Conversation? selectedConversation;
  String messageInput = '';

  late final UserId currentUserId;
  late final User currentUser;
  late final List<Conversation> conversations;
  late final Map<String, List<Message>> conversationMessages;

  @override
  void initState() {
    super.initState();
    currentUserId = UserId('user-web-me');
    currentUser = User(
      id: currentUserId,
      phoneNumber: PhoneNumber.parse('+15551234567'),
      displayName: 'Alex Rivers',
      createdAt: DateTime.now(),
      isOnline: true,
    );

    final contact1 = User(
      id: UserId('user-sarah'),
      phoneNumber: PhoneNumber.parse('+15559876543'),
      displayName: 'Sarah Connor',
      createdAt: DateTime.now(),
      isOnline: true,
    );

    final contact2 = User(
      id: UserId('user-james'),
      phoneNumber: PhoneNumber.parse('+15553334444'),
      displayName: 'James Holden',
      createdAt: DateTime.now(),
      isOnline: false,
    );

    final now = DateTime.now();

    final conv1 = Conversation(
      id: ConversationId('conv-1'),
      user1: currentUser,
      user2: contact1,
      unreadCount: 2,
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
      lastMessage: Message(
        id: MessageId('msg-1-2'),
        conversationId: ConversationId('conv-1'),
        senderId: contact1.id,
        recipientId: currentUserId,
        content: MessageContent(text: 'Hey Alex! Did you review the latest Flutter and Jaspr designs?'),
        sentAt: now.subtract(const Duration(minutes: 5)),
        status: MessageStatus.delivered,
      ),
    );

    final conv2 = Conversation(
      id: ConversationId('conv-2'),
      user1: currentUser,
      user2: contact2,
      unreadCount: 0,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(hours: 1)),
      lastMessage: Message(
        id: MessageId('msg-2-1'),
        conversationId: ConversationId('conv-2'),
        senderId: currentUserId,
        recipientId: contact2.id,
        content: MessageContent(text: 'The Serverpod backend streaming is working perfectly!'),
        sentAt: now.subtract(const Duration(hours: 1)),
        status: MessageStatus.read,
      ),
    );

    conversations = [conv1, conv2];
    selectedConversation = conv1;

    conversationMessages = {
      'conv-1': [
        Message(
          id: MessageId('msg-1-1'),
          conversationId: ConversationId('conv-1'),
          senderId: currentUserId,
          recipientId: contact1.id,
          content: MessageContent(text: 'Hi Sarah, are you online?'),
          sentAt: now.subtract(const Duration(minutes: 10)),
          status: MessageStatus.read,
        ),
        Message(
          id: MessageId('msg-1-2'),
          conversationId: ConversationId('conv-1'),
          senderId: contact1.id,
          recipientId: currentUserId,
          content: MessageContent(text: 'Hey Alex! Did you review the latest Flutter and Jaspr designs?'),
          sentAt: now.subtract(const Duration(minutes: 5)),
          status: MessageStatus.delivered,
        ),
      ],
      'conv-2': [
        Message(
          id: MessageId('msg-2-1'),
          conversationId: ConversationId('conv-2'),
          senderId: currentUserId,
          recipientId: contact2.id,
          content: MessageContent(text: 'The Serverpod backend streaming is working perfectly!'),
          sentAt: now.subtract(const Duration(hours: 1)),
          status: MessageStatus.read,
        ),
      ],
    };
  }

  void _handleSendMessage(String text) {
    if (selectedConversation == null || text.trim().isEmpty) return;

    final convId = selectedConversation!.id.value;
    final partner = selectedConversation!.otherParticipant(currentUserId);
    final newMessage = Message(
      id: MessageId('msg-${DateTime.now().millisecondsSinceEpoch}'),
      conversationId: selectedConversation!.id,
      senderId: currentUserId,
      recipientId: partner.id,
      content: MessageContent(text: text.trim()),
      sentAt: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      final list = conversationMessages[convId] ?? [];
      conversationMessages[convId] = [...list, newMessage];
      messageInput = '';
    });
  }

  @override
  Component build(BuildContext context) {
    final activeConv = selectedConversation;
    final activeMessages =
        activeConv != null ? (conversationMessages[activeConv.id.value] ?? []) : <Message>[];

    return div(
      classes: 'h-screen w-screen overflow-hidden ${isDarkMode ? 'dark' : ''}',
      [
        div(
          classes:
              'h-full w-full flex bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100',
          [
            // Responsive Sidebar
            div(
              classes:
                  '${activeConv != null ? 'hidden md:flex' : 'flex'} w-full md:w-80 lg:w-96 h-full',
              [
                WebSidebar(
                  conversations: conversations,
                  selectedConversation: selectedConversation,
                  onSelectConversation: (conv) {
                    setState(() {
                      selectedConversation = conv;
                    });
                  },
                  onNewChat: () {
                    // Start new chat placeholder
                  },
                  onToggleTheme: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  isDarkMode: isDarkMode,
                  currentUserName: currentUser.displayName,
                ),
              ],
            ),

            // Active Chat View or Empty Selection placeholder
            div(
              classes:
                  '${activeConv == null ? 'hidden md:flex' : 'flex'} flex-1 h-full',
              [
                if (activeConv != null)
                  WebChatView(
                    conversation: activeConv,
                    messages: activeMessages,
                    currentUserId: currentUserId,
                    onBack: () {
                      setState(() {
                        selectedConversation = null;
                      });
                    },
                    inputText: messageInput,
                    onInputChanged: (val) {
                      setState(() {
                        messageInput = val;
                      });
                    },
                    onSendMessage: _handleSendMessage,
                  )
                else
                  div(
                    classes:
                        'flex-1 h-full flex flex-col items-center justify-center text-slate-400 dark:text-slate-500',
                    [
                      const ChatIcon(WebChatIconType.profile, size: 48),
                      div(classes: 'h-4', []),
                      ChatText.bodyMedium(
                        localize('conversations.empty_state'),
                        className: 'text-center',
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
