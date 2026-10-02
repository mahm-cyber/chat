import 'dart:async';
import 'package:chat_room/chat_room.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements IChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late StreamController<List<Message>> messagesController;

  final testConversationId = ConversationId('conv-123');
  final testCurrentUserId = UserId('user-me');

  final testMessage = Message(
    id: MessageId('msg-1'),
    conversationId: testConversationId,
    senderId: UserId('user-partner'),
    recipientId: testCurrentUserId,
    content: MessageContent(text: 'Hello from partner!'),
    status: MessageStatus.delivered,
    sentAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(MessageId('dummy'));
    registerFallbackValue(ConversationId('dummy'));
  });

  setUp(() {
    mockChatRepository = MockChatRepository();
    messagesController = StreamController<List<Message>>.broadcast();

    when(() => mockChatRepository.watchMessages(testConversationId))
        .thenAnswer((_) => messagesController.stream);
    when(() => mockChatRepository.markMessageRead(any()))
        .thenAnswer((_) async {});
    when(() => mockChatRepository.setTypingStatus(
          conversationId: any(named: 'conversationId'),
          isTyping: any(named: 'isTyping'),
        )).thenAnswer((_) async {});
  });

  tearDown(() {
    messagesController.close();
  });

  Widget buildTestableWidget({
    required VoidCallback onBack,
  }) {
    return ProviderScope(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockChatRepository),
        currentUserIdProvider.overrideWithValue(testCurrentUserId),
      ],
      child: MaterialApp(
        home: ChatRoomScreen(
          conversationId: testConversationId,
          currentUserId: testCurrentUserId,
          partnerId: UserId('user-partner'),
          partnerName: 'Alice Partner',
          isPartnerOnline: true,
          onBack: onBack,
        ),
      ),
    );
  }

  testWidgets('renders partner details and messages', (tester) async {
    var backCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onBack: () => backCalled = true,
      ),
    );

    messagesController.add([testMessage]);
    await tester.pumpAndSettle();

    expect(find.text('Alice Partner'), findsOneWidget);
    expect(find.text('Hello from partner!'), findsOneWidget);
    expect(
        find.byKey(Key(ChatRoomTestIds.messageItem('msg-1'))), findsOneWidget);

    // Test back button
    await tester.tap(find.byKey(const Key(ChatRoomTestIds.backButton)));
    await tester.pumpAndSettle();
    expect(backCalled, isTrue);
  });

  testWidgets('typing message and sending calls chatRepository.sendMessage',
      (tester) async {
    when(() => mockChatRepository.sendMessage(
          conversationId: testConversationId,
          recipientId: UserId('user-partner'),
          content: MessageContent(text: 'Testing send flow'),
        )).thenAnswer((_) async => Message(
          id: MessageId('msg-sent-1'),
          conversationId: testConversationId,
          senderId: testCurrentUserId,
          recipientId: UserId('user-partner'),
          content: MessageContent(text: 'Testing send flow'),
          status: MessageStatus.sent,
          sentAt: DateTime.now(),
        ));

    await tester.pumpWidget(
      buildTestableWidget(
        onBack: () {},
      ),
    );

    messagesController.add([]);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key(ChatRoomTestIds.messageInput)),
      'Testing send flow',
    );
    await tester.tap(find.byKey(const Key(ChatRoomTestIds.sendButton)));
    await tester.pumpAndSettle();

    verify(() => mockChatRepository.sendMessage(
          conversationId: testConversationId,
          recipientId: UserId('user-partner'),
          content: MessageContent(text: 'Testing send flow'),
        )).called(1);
  });
}
