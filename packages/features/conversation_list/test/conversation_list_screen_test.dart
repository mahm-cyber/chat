import 'dart:async';
import 'package:conversation_list/conversation_list.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements IChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late StreamController<List<Conversation>> conversationsController;
  final currentUserId = UserId('user-me');

  final otherUser = User(
    id: UserId('user-partner'),
    phoneNumber: PhoneNumber.parse('+15559876543'),
    displayName: 'Partner Alice',
    isOnline: true,
    createdAt: DateTime.now(),
  );

  final testConversation = Conversation(
    id: ConversationId('conv-1'),
    user1: User(
      id: currentUserId,
      phoneNumber: PhoneNumber.parse('+15551234567'),
      displayName: 'Me',
      createdAt: DateTime.now(),
    ),
    user2: otherUser,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lastMessage: Message(
      id: MessageId('msg-1'),
      conversationId: ConversationId('conv-1'),
      senderId: UserId('user-partner'),
      recipientId: currentUserId,
      content: MessageContent(text: 'Hey there!'),
      status: MessageStatus.delivered,
      sentAt: DateTime.now(),
    ),
    unreadCount: 2,
  );

  setUp(() {
    mockChatRepository = MockChatRepository();
    conversationsController = StreamController<List<Conversation>>.broadcast();
    when(() => mockChatRepository.watchConversations())
        .thenAnswer((_) => conversationsController.stream);
  });

  tearDown(() {
    conversationsController.close();
  });

  Widget buildTestableWidget({
    required void Function(ConversationId) onSelectConversation,
    required VoidCallback onNewChat,
    required VoidCallback onOpenProfile,
    required VoidCallback onOpenSettings,
  }) {
    return ProviderScope(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockChatRepository),
        currentUserIdProvider.overrideWithValue(currentUserId),
      ],
      child: MaterialApp(
        home: ConversationListScreen(
          onSelectConversation: onSelectConversation,
          onNewChat: onNewChat,
          onOpenProfile: onOpenProfile,
          onOpenSettings: onOpenSettings,
        ),
      ),
    );
  }

  testWidgets('renders empty state when no conversations exist',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        onSelectConversation: (_) {},
        onNewChat: () {},
        onOpenProfile: () {},
        onOpenSettings: () {},
      ),
    );

    conversationsController.add([]);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key(ConversationListTestIds.emptyView)),
        findsOneWidget);
  });

  testWidgets(
      'renders conversation item and triggers callbacks on tap',
      (tester) async {
    ConversationId? selectedId;
    var newChatCalled = false;
    var profileCalled = false;
    var settingsCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onSelectConversation: (id) => selectedId = id,
        onNewChat: () => newChatCalled = true,
        onOpenProfile: () => profileCalled = true,
        onOpenSettings: () => settingsCalled = true,
      ),
    );

    conversationsController.add([testConversation]);
    await tester.pumpAndSettle();

    expect(find.text('Partner Alice'), findsOneWidget);
    expect(find.text('Hey there!'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // unread badge

    // Tap conversation item
    await tester.tap(find.byKey(
        Key(ConversationListTestIds.conversationItem('conv-1'))));
    await tester.pumpAndSettle();
    expect(selectedId, equals(ConversationId('conv-1')));

    // Tap new chat
    await tester.tap(find.byKey(const Key(ConversationListTestIds.newChatButton)));
    await tester.pumpAndSettle();
    expect(newChatCalled, isTrue);

    // Tap profile
    await tester.tap(find.byKey(const Key(ConversationListTestIds.profileButton)));
    await tester.pumpAndSettle();
    expect(profileCalled, isTrue);

    // Tap settings
    await tester.tap(find.byKey(const Key(ConversationListTestIds.settingsButton)));
    await tester.pumpAndSettle();
    expect(settingsCalled, isTrue);
  });
}
