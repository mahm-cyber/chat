import 'package:chat_web/src/localization.dart';
import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';

void main() {
  group('Web Chat Application Tests', () {
    test('localizes keys correctly from WebTranslations', () {
      expect(localize('conversations.title'), equals('Messages'));
      expect(localize('chat.send'), equals('Send'));
      expect(localize('unknown_key'), equals('unknown_key'));
    });

    test('supports dynamic translation bundle overrides', () {
      WebTranslations.loadTranslations({'chat.send': 'Envoyer'});
      expect(localize('chat.send'), equals('Envoyer'));
    });

    test('verifies domain models compatibility in web client', () {
      final user = User(
        id: UserId('user-web-1'),
        phoneNumber: PhoneNumber.parse('+15550001111'),
        displayName: 'Test Web User',
        createdAt: DateTime.now(),
        isOnline: true,
      );

      final conv = Conversation(
        id: ConversationId('conv-web-1'),
        user1: user,
        user2: User(
          id: UserId('user-web-2'),
          phoneNumber: PhoneNumber.parse('+15550002222'),
          displayName: 'Partner User',
          createdAt: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(conv.id.value, equals('conv-web-1'));
      expect(conv.otherParticipant(user.id).displayName, equals('Partner User'));
    });
  });
}
