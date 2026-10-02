import '../entities/user.dart';
import '../value_objects/phone_number.dart';

abstract class IAuthRepository {
  Stream<User?> watchCurrentUser();
  Future<User?> getCurrentUser();
  Future<String> sendOtpCode(PhoneNumber phoneNumber);
  Future<User> verifySmsCode({
    required String verificationId,
    required String smsCode,
  });
  Future<User> verifyFirebaseIdToken(String firebaseIdToken);
  Future<void> signOut();
}
