import 'package:chat_client/chat_client.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

class MockEndpointChat extends Mock implements EndpointChat {}

void main() {
  group('ChatRepository', () {
    late MockClient client;
    late MockEndpointChat mockChat;
    late KeyValueStorage storage;
    late ChatRepository repo;

    final now = DateTime.now();

    setUp(() async {
      client = MockClient();
      mockChat = MockEndpointChat();
      storage = KeyValueStorage();
      when(() => client.chat).thenReturn(mockChat);
      repo = ChatRepository(client: client, storage: storage);

      // Pre-seed an authenticated user
      await storage.saveUser(const UserCM(
        id: '1',
        phoneNumber: '+12345678901',
        displayName: 'Sender User',
        createdAt: '2026-01-01T00:00:00Z',
      ));
    });

    tearDown(() {
      repo.dispose();
    });

    test('getOrCreateConversation returns conversation and caches it',
        () async {
      final model = ConversationModel(
        id: 100,
        user1Id: 1,
        user2Id: 2,
        unreadCountUser1: 0,
        unreadCountUser2: 0,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockChat.getOrCreateConversation(
            currentUserId: 1,
            recipientId: 2,
          )).thenAnswer((_) async => model);

      final conversation =
          await repo.getOrCreateConversation(UserId('2'));

      expect(conversation.id.value, equals('100'));
      expect(conversation.user1Id.value, equals('1'));
      expect(conversation.user2Id.value, equals('2'));

      final cached = await storage.getConversations();
      expect(cached.length, equals(1));
      expect(cached.first.id, equals('100'));
    });

    test('sendMessage sends message and updates cache and stream', () async {
      final msgModel = MessageModel(
        id: 50,
        conversationId: 100,
        senderId: 1,
        recipientId: 2,
        content: 'Hello World',
        status: 'sent',
        sentAt: now,
      );

      when(() => mockChat.sendMessage(
            conversationId: 100,
            senderId: 1,
            recipientId: 2,
            content: 'Hello World',
            attachmentUrls: null,
          )).thenAnswer((_) async => msgModel);

      final message = await repo.sendMessage(
        conversationId: ConversationId('100'),
        recipientId: UserId('2'),
        content: MessageContent.create(text: 'Hello World'),
      );

      expect(message.id.value, equals('50'));
      expect(message.content.text, equals('Hello World'));
      expect(message.status, equals(MessageStatus.sent));

      final cached = await storage.getMessages('100');
      expect(cached.length, equals(1));
      expect(cached.first.text, equals('Hello World'));
    });

    test('watchMessages emits cached messages first', () async {
      await storage.saveMessages('100', [
        MessageCM(
          id: '50',
          conversationId: '100',
          senderId: '1',
          recipientId: '2',
          text: 'Cached Msg',
          status: 'sent',
          sentAt: now.toIso8601String(),
        ),
      ]);

      when(() => mockChat.getMessages(conversationId: 100))
          .thenAnswer((_) async => []);
      when(() => mockChat.watchConversation(100))
          .thenAnswer((_) => const Stream.empty());

      final stream = repo.watchMessages(ConversationId('100'));
      final firstEmission = await stream.first;

      expect(firstEmission.length, equals(1));
      expect(firstEmission.first.content.text, equals('Cached Msg'));
    });

    test('markMessageDelivered and markMessageRead delegate to client', () async {
      when(() => mockChat.markMessageDelivered(
            messageId: any(named: 'messageId'),
            conversationId: any(named: 'conversationId'),
            senderId: any(named: 'senderId'),
          )).thenAnswer((_) async => {});

      when(() => mockChat.markMessageRead(
            messageId: any(named: 'messageId'),
            conversationId: any(named: 'conversationId'),
            senderId: any(named: 'senderId'),
          )).thenAnswer((_) async => {});

      await repo.markMessageDelivered(MessageId('50'));
      await repo.markMessageRead(MessageId('50'));

      verify(() => mockChat.markMessageDelivered(
            messageId: 50,
            conversationId: any(named: 'conversationId'),
            senderId: 1,
          )).called(1);

      verify(() => mockChat.markMessageRead(
            messageId: 50,
            conversationId: any(named: 'conversationId'),
            senderId: 1,
          )).called(1);
    });

    test('setTypingStatus sends typing event to client', () async {
      when(() => mockChat.sendTypingEvent(
            conversationId: 100,
            senderId: 1,
            isTyping: true,
          )).thenAnswer((_) async => {});

      await repo.setTypingStatus(
        conversationId: ConversationId('100'),
        isTyping: true,
      );

      verify(() => mockChat.sendTypingEvent(
            conversationId: 100,
            senderId: 1,
            isTyping: true,
          )).called(1);
    });
  });
}
