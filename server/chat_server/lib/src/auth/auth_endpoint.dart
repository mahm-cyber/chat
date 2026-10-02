import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  /// Authenticates or registers a user via verified Firebase phone credentials
  Future<AppUser> authenticateWithFirebasePhone(
    Session session, {
    required String firebaseUid,
    required String phoneNumber,
    String? displayName,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');

    // 1. Check for existing registered user
    final existingUser = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(cleanPhone) | t.firebaseUid.equals(firebaseUid),
    );

    if (existingUser != null) {
      existingUser.lastSeenAt = DateTime.now().toUtc();
      if (existingUser.firebaseUid != firebaseUid) {
        existingUser.firebaseUid = firebaseUid;
      }
      return await AppUser.db.updateRow(session, existingUser);
    }

    // 2. Provision new user profile
    final defaultName = displayName ??
        (cleanPhone.length >= 4
            ? 'User ${cleanPhone.substring(cleanPhone.length - 4)}'
            : 'New User');

    final newUser = AppUser(
      firebaseUid: firebaseUid,
      phoneNumber: cleanPhone,
      displayName: defaultName,
      notificationsEnabled: true,
      lastSeenAt: DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
    );

    return await AppUser.db.insertRow(session, newUser);
  }

  Future<bool> signOut(Session session) async {
    return true;
  }
}
