import '../entities/user.dart';
import '../value_objects/phone_number.dart';

abstract class IAuthRepository {
  Stream<User?> watchCurrentUser();
  Future<User?> getCurrentUser();
  Future<void> sendOtpCode(PhoneNumber phoneNumber);
  Future<User> verifyFirebaseIdToken(String firebaseIdToken);
  Future<void> signOut();
}
