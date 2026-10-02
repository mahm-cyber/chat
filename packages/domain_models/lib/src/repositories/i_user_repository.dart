import '../entities/user.dart';
import '../value_objects/identifiers.dart';
import '../value_objects/phone_number.dart';

abstract class IUserRepository {
  Future<User> getUser(UserId userId);
  Future<User> updateProfile({
    String? displayName,
    String? bio,
    String? photoUrl,
  });
  Future<User> toggleNotifications(bool enabled);
  Future<List<User>> searchUsers(String query);
  Future<List<User>> syncContacts(List<PhoneNumber> phoneNumbers);
  Future<String> getAvatarUploadUrl(String fileName);
}
