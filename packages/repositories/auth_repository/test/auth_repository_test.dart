import 'package:auth_repository/auth_repository.dart';
import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

class MockEndpointAuth extends Mock implements EndpointAuth {}

void main() {
  group('AuthRepository', () {
    late MockClient client;
    late MockEndpointAuth mockAuth;
    late KeyValueStorage storage;
    late AuthRepository repo;

    setUp(() {
      client = MockClient();
      mockAuth = MockEndpointAuth();
      storage = KeyValueStorage();
      when(() => client.auth).thenReturn(mockAuth);
      repo = AuthRepository(client: client, storage: storage);
    });

    tearDown(() {
      repo.dispose();
    });

    test('verifyFirebaseIdToken parses token, calls client and caches user',
        () async {
      final now = DateTime.now();
      final appUser = AppUser(
        id: 42,
        firebaseUid: 'fb-123',
        phoneNumber: '+1234567890',
        displayName: 'Test User',
        notificationsEnabled: true,
        createdAt: now,
      );

      when(() => mockAuth.authenticateWithFirebasePhone(
            firebaseUid: 'fb-123',
            phoneNumber: '+1234567890',
            displayName: 'Test User',
          )).thenAnswer((_) async => appUser);

      final user = await repo.verifyFirebaseIdToken('fb-123:+1234567890:Test User');

      expect(user.id.value, equals('42'));
      expect(user.phoneNumber.value, equals('+1234567890'));
      expect(user.displayName, equals('Test User'));

      final cached = await storage.getUser();
      expect(cached?.id, equals('42'));
      expect(cached?.displayName, equals('Test User'));

      final currentUser = await repo.getCurrentUser();
      expect(currentUser?.id.value, equals('42'));
    });

    test('signOut clears storage and emits null', () async {
      await storage.saveUser(const UserCM(
        id: '1',
        phoneNumber: '+12345678901',
        displayName: 'User',
        createdAt: '2026-01-01T00:00:00Z',
      ));

      when(() => mockAuth.signOut()).thenAnswer((_) async => true);

      await repo.initialize();
      expect((await repo.getCurrentUser())?.id.value, equals('1'));

      await repo.signOut();
      expect(await repo.getCurrentUser(), isNull);
      expect(await storage.getUser(), isNull);
    });

    test('sendOtpCode calls delegate when provided', () async {
      String? sentPhone;
      final customRepo = AuthRepository(
        client: client,
        storage: storage,
        otpSender: (phone) async => sentPhone = phone,
      );

      await customRepo.sendOtpCode(PhoneNumber.parse('+19876543210'));
      expect(sentPhone, equals('+19876543210'));
      customRepo.dispose();
    });
  });
}
