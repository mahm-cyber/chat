import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Chat & User endpoints', (sessionBuilder, endpoints) {
    test('when authenticating with phone then user is registered', () async {
      final user = await endpoints.auth.authenticateWithFirebasePhone(
        sessionBuilder,
        firebaseUid: 'test_firebase_uid_1',
        phoneNumber: '+12025550199',
        displayName: 'Test User',
      );

      expect(user.displayName, equals('Test User'));
      expect(user.phoneNumber, equals('+12025550199'));
      expect(user.notificationsEnabled, isTrue);
    });

    test('when updating profile and notification settings then changes persist', () async {
      final user = await endpoints.auth.authenticateWithFirebasePhone(
        sessionBuilder,
        firebaseUid: 'test_firebase_uid_2',
        phoneNumber: '+12025550200',
        displayName: 'Original Name',
      );

      final updated = await endpoints.user.updateProfile(
        sessionBuilder,
        userId: user.id!,
        displayName: 'Updated Name',
        bio: 'Hello, this is my bio',
      );

      expect(updated?.displayName, equals('Updated Name'));
      expect(updated?.bio, equals('Hello, this is my bio'));

      final disabledNotifications = await endpoints.user.toggleNotifications(
        sessionBuilder,
        userId: user.id!,
        enabled: false,
      );

      expect(disabledNotifications?.notificationsEnabled, isFalse);
    });

    test('when creating conversation and sending message then message is stored and delivered', () async {
      final userA = await endpoints.auth.authenticateWithFirebasePhone(
        sessionBuilder,
        firebaseUid: 'uid_a',
        phoneNumber: '+12025550201',
      );

      final userB = await endpoints.auth.authenticateWithFirebasePhone(
        sessionBuilder,
        firebaseUid: 'uid_b',
        phoneNumber: '+12025550202',
      );

      final conversation = await endpoints.chat.getOrCreateConversation(
        sessionBuilder,
        currentUserId: userA.id!,
        recipientId: userB.id!,
      );

      expect(conversation.id, isNotNull);

      final message = await endpoints.chat.sendMessage(
        sessionBuilder,
        conversationId: conversation.id!,
        senderId: userA.id!,
        recipientId: userB.id!,
        content: 'Hey there from User A!',
      );

      expect(message.id, isNotNull);
      expect(message.content, equals('Hey there from User A!'));
      expect(message.status, equals('sent'));

      final history = await endpoints.chat.getMessages(
        sessionBuilder,
        conversationId: conversation.id!,
        limit: 50,
      );

      expect(history.length, greaterThanOrEqualTo(1));
      expect(history.any((m) => m.content == 'Hey there from User A!'), isTrue);

      await endpoints.chat.markMessageRead(
        sessionBuilder,
        messageId: message.id!,
        conversationId: conversation.id!,
        senderId: userB.id!,
      );
    });
  });
}
