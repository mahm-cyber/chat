import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockClient extends Mock implements Client {}

class MockEndpointUser extends Mock implements EndpointUser {}

void main() {
  group('UserRepository', () {
    late MockClient client;
    late MockEndpointUser mockUser;
    late KeyValueStorage storage;
    late UserRepository repo;

    setUp(() {
      client = MockClient();
      mockUser = MockEndpointUser();
      storage = KeyValueStorage();
      when(() => client.user).thenReturn(mockUser);
      repo = UserRepository(client: client, storage: storage);
    });

    test('getUser returns user when found, throws when not found', () async {
      final now = DateTime.now();
      final appUser = AppUser(
        id: 10,
        firebaseUid: 'fb-10',
        phoneNumber: '+12345678901',
        displayName: 'John Doe',
        notificationsEnabled: true,
        createdAt: now,
      );

      when(() => mockUser.getProfile(10)).thenAnswer((_) async => appUser);
      when(() => mockUser.getProfile(99)).thenAnswer((_) async => null);

      final user = await repo.getUser(UserId('10'));
      expect(user.id.value, equals('10'));
      expect(user.displayName, equals('John Doe'));

      expect(
        () => repo.getUser(UserId('99')),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('updateProfile updates server and updates local cache', () async {
      await storage.saveUser(const UserCM(
        id: '10',
        phoneNumber: '+12345678901',
        displayName: 'Old Name',
        createdAt: '2026-01-01T00:00:00Z',
      ));

      final updated = AppUser(
        id: 10,
        firebaseUid: 'fb-10',
        phoneNumber: '+12345678901',
        displayName: 'New Name',
        bio: 'Updated bio',
        notificationsEnabled: true,
        createdAt: DateTime.now(),
      );

      when(() => mockUser.updateProfile(
            userId: 10,
            displayName: 'New Name',
            bio: 'Updated bio',
            photoUrl: null,
          )).thenAnswer((_) async => updated);

      final result = await repo.updateProfile(
        displayName: 'New Name',
        bio: 'Updated bio',
      );

      expect(result.displayName, equals('New Name'));
      expect(result.bio, equals('Updated bio'));

      final cached = await storage.getUser();
      expect(cached?.displayName, equals('New Name'));
      expect(cached?.bio, equals('Updated bio'));
    });

    test('toggleNotifications updates notification setting', () async {
      await storage.saveUser(const UserCM(
        id: '10',
        phoneNumber: '+12345678901',
        displayName: 'User',
        notificationsEnabled: true,
        createdAt: '2026-01-01T00:00:00Z',
      ));

      final updated = AppUser(
        id: 10,
        firebaseUid: 'fb-10',
        phoneNumber: '+12345678901',
        displayName: 'User',
        notificationsEnabled: false,
        createdAt: DateTime.now(),
      );

      when(() => mockUser.toggleNotifications(
            userId: 10,
            enabled: false,
          )).thenAnswer((_) async => updated);

      final result = await repo.toggleNotifications(false);
      expect(result.notificationsEnabled, isFalse);

      final cached = await storage.getUser();
      expect(cached?.notificationsEnabled, isFalse);
    });

    test('searchUsers calls server and maps results', () async {
      final appUser = AppUser(
        id: 5,
        firebaseUid: 'fb-5',
        phoneNumber: '+19999999999',
        displayName: 'Searched User',
        notificationsEnabled: true,
        createdAt: DateTime.now(),
      );

      when(() => mockUser.searchUsers('test'))
          .thenAnswer((_) async => [appUser]);

      final results = await repo.searchUsers('test');
      expect(results.length, equals(1));
      expect(results.first.displayName, equals('Searched User'));
    });

    test('syncContacts queries server with phone list', () async {
      final appUser = AppUser(
        id: 7,
        firebaseUid: 'fb-7',
        phoneNumber: '+15555555555',
        displayName: 'Contact 1',
        notificationsEnabled: true,
        createdAt: DateTime.now(),
      );

      when(() => mockUser.syncContacts(['+15555555555']))
          .thenAnswer((_) async => [appUser]);

      final results =
          await repo.syncContacts([PhoneNumber.parse('+15555555555')]);
      expect(results.length, equals(1));
      expect(results.first.phoneNumber.value, equals('+15555555555'));
    });

    test('getAvatarUploadUrl retrieves upload path', () async {
      when(() => mockUser.getAvatarUploadDescription('avatar.png'))
          .thenAnswer((_) async => 'uploads/avatars/avatar.png');

      final url = await repo.getAvatarUploadUrl('avatar.png');
      expect(url, equals('uploads/avatars/avatar.png'));
    });
  });
}
