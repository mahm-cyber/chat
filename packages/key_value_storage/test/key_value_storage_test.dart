import 'package:key_value_storage/key_value_storage.dart';
import 'package:test/test.dart';

void main() {
  group('KeyValueStorage', () {
    late KeyValueStorage storage;

    setUp(() {
      storage = KeyValueStorage();
    });

    test('saves, retrieves, and clears user', () async {
      expect(await storage.getUser(), isNull);

      final user = UserCM(
        id: 'u-123',
        phoneNumber: '+15551234567',
        displayName: 'Test User',
        createdAt: '2026-01-01T00:00:00.000Z',
        bio: 'Bio text',
        photoUrl: 'https://example.com/avatar.png',
        notificationsEnabled: true,
      );

      await storage.saveUser(user);
      final retrieved = await storage.getUser();

      expect(retrieved, isNotNull);
      expect(retrieved?.id, 'u-123');
      expect(retrieved?.phoneNumber, '+15551234567');
      expect(retrieved?.displayName, 'Test User');

      await storage.clearUser();
      expect(await storage.getUser(), isNull);
    });

    test('saves and retrieves conversations', () async {
      expect(await storage.getConversations(), isEmpty);

      final conv = ConversationCM(
        id: 'c-1',
        user1Id: 'u-1',
        user2Id: 'u-2',
        unreadCount: 3,
        createdAt: '2026-01-01T00:00:00.000Z',
        updatedAt: '2026-01-02T00:00:00.000Z',
      );

      await storage.saveConversations([conv]);
      final retrieved = await storage.getConversations();

      expect(retrieved.length, 1);
      expect(retrieved.first.id, 'c-1');
      expect(retrieved.first.unreadCount, 3);
    });

    test('saves and retrieves messages per conversation', () async {
      expect(await storage.getMessages('c-1'), isEmpty);

      final msg = MessageCM(
        id: 'm-1',
        conversationId: 'c-1',
        senderId: 'u-1',
        recipientId: 'u-2',
        text: 'Hello World',
        sentAt: '2026-01-01T12:00:00.000Z',
        status: 'delivered',
      );

      await storage.saveMessages('c-1', [msg]);
      final retrieved = await storage.getMessages('c-1');

      expect(retrieved.length, 1);
      expect(retrieved.first.id, 'm-1');
      expect(retrieved.first.text, 'Hello World');
      expect(retrieved.first.status, 'delivered');
    });

    test('saves, retrieves translations and version', () async {
      expect(await storage.getTranslations('en'), isNull);
      expect(await storage.getTranslationVersion('en'), isNull);

      final translations = {
        'auth.welcome_title': 'Welcome to Chat',
        'auth.sign_in': 'Sign In',
      };

      await storage.saveTranslations('en', translations, 2);

      final retrieved = await storage.getTranslations('en');
      final version = await storage.getTranslationVersion('en');

      expect(retrieved, isNotNull);
      expect(retrieved?['auth.welcome_title'], 'Welcome to Chat');
      expect(version, 2);
    });

    test('saves and retrieves theme mode and notification settings', () async {
      expect(await storage.getThemeMode(), isNull);
      expect(await storage.getNotificationSetting(), isTrue);

      await storage.saveThemeMode('dark');
      await storage.saveNotificationSetting(false);

      expect(await storage.getThemeMode(), 'dark');
      expect(await storage.getNotificationSetting(), isFalse);

      await storage.clearAll();
      expect(await storage.getThemeMode(), isNull);
      expect(await storage.getNotificationSetting(), isTrue);
    });
  });
}
