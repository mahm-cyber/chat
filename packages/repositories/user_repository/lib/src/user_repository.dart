import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

class UserRepository implements IUserRepository {
  final Client client;
  final KeyValueStorage storage;

  UserRepository({
    required this.client,
    required this.storage,
  });

  @override
  Future<User> getUser(UserId userId) async {
    final idInt = int.tryParse(userId.value);
    if (idInt == null) {
      throw DomainInvariantViolationException('Invalid user ID: ${userId.value}');
    }

    final appUser = await client.user.getProfile(idInt);
    if (appUser == null) {
      throw EntityNotFoundException('User with id ${userId.value} not found');
    }

    return _mapAppUserToDomain(appUser);
  }

  @override
  Future<User> updateProfile({
    String? displayName,
    String? bio,
    String? photoUrl,
  }) async {
    final current = await storage.getUser();
    if (current == null) {
      throw const UnauthorizedDomainActionException('No authenticated user found');
    }

    final idInt = int.parse(current.id);
    final updated = await client.user.updateProfile(
      userId: idInt,
      displayName: displayName,
      bio: bio,
      photoUrl: photoUrl,
    );

    if (updated == null) {
      throw EntityNotFoundException('User $idInt not found on server');
    }

    final domainUser = _mapAppUserToDomain(updated);
    await storage.saveUser(_mapDomainToUserCM(domainUser));
    return domainUser;
  }

  @override
  Future<User> toggleNotifications(bool enabled) async {
    final current = await storage.getUser();
    if (current == null) {
      throw const UnauthorizedDomainActionException('No authenticated user found');
    }

    final idInt = int.parse(current.id);
    final updated = await client.user.toggleNotifications(
      userId: idInt,
      enabled: enabled,
    );

    if (updated == null) {
      throw EntityNotFoundException('User $idInt not found on server');
    }

    final domainUser = _mapAppUserToDomain(updated);
    await storage.saveUser(_mapDomainToUserCM(domainUser));
    return domainUser;
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    final results = await client.user.searchUsers(query);
    return results.map(_mapAppUserToDomain).toList();
  }

  @override
  Future<List<User>> syncContacts(List<PhoneNumber> phoneNumbers) async {
    final strings = phoneNumbers.map((p) => p.value).toList();
    final results = await client.user.syncContacts(strings);
    return results.map(_mapAppUserToDomain).toList();
  }

  @override
  Future<String> getAvatarUploadUrl(String fileName) async {
    final uploadDesc = await client.user.getAvatarUploadDescription(fileName);
    if (uploadDesc == null) {
      throw const DomainInvariantViolationException(
        'Failed to generate avatar upload URL from server',
      );
    }
    return uploadDesc;
  }

  User _mapAppUserToDomain(AppUser appUser) {
    return User(
      id: UserId(appUser.id.toString()),
      phoneNumber: PhoneNumber.parse(appUser.phoneNumber),
      displayName: appUser.displayName,
      bio: appUser.bio,
      photoUrl: appUser.photoUrl,
      notificationsEnabled: appUser.notificationsEnabled,
      lastSeenAt: appUser.lastSeenAt,
      createdAt: appUser.createdAt,
    );
  }

  UserCM _mapDomainToUserCM(User user) {
    return UserCM(
      id: user.id.value,
      phoneNumber: user.phoneNumber.value,
      displayName: user.displayName,
      bio: user.bio,
      photoUrl: user.photoUrl,
      notificationsEnabled: user.notificationsEnabled,
      lastSeenAt: user.lastSeenAt?.toIso8601String(),
      createdAt: user.createdAt.toIso8601String(),
    );
  }
}
