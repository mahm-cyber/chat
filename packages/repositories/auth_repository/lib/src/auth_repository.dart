import 'dart:async';
import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

typedef FirebaseTokenVerifier = Future<({String firebaseUid, String phoneNumber, String? displayName})> Function(String token);
typedef PhoneOtpSender = Future<void> Function(String phoneNumber);

class AuthRepository implements IAuthRepository {
  final Client client;
  final KeyValueStorage storage;
  final FirebaseTokenVerifier? tokenVerifier;
  final PhoneOtpSender? otpSender;

  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();

  User? _currentUser;

  AuthRepository({
    required this.client,
    required this.storage,
    this.tokenVerifier,
    this.otpSender,
  });

  Future<void> initialize() async {
    final cached = await storage.getUser();
    if (cached != null) {
      _currentUser = _mapUserCMToDomain(cached);
      _userController.add(_currentUser);
    }
  }

  @override
  Stream<User?> watchCurrentUser() async* {
    if (_currentUser != null) {
      yield _currentUser;
    } else {
      final cached = await storage.getUser();
      if (cached != null) {
        _currentUser = _mapUserCMToDomain(cached);
        yield _currentUser;
      } else {
        yield null;
      }
    }
    yield* _userController.stream;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final cached = await storage.getUser();
    if (cached != null) {
      _currentUser = _mapUserCMToDomain(cached);
      return _currentUser;
    }
    return null;
  }

  @override
  Future<String> sendOtpCode(PhoneNumber phoneNumber) async {
    if (otpSender != null) {
      await otpSender!(phoneNumber.value);
    }
    return 'verification_${phoneNumber.value}';
  }

  @override
  Future<User> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    return verifyFirebaseIdToken('$verificationId:$smsCode');
  }

  @override
  Future<User> verifyFirebaseIdToken(String firebaseIdToken) async {
    String firebaseUid;
    String phoneNumber;
    String? displayName;

    if (tokenVerifier != null) {
      final credentials = await tokenVerifier!(firebaseIdToken);
      firebaseUid = credentials.firebaseUid;
      phoneNumber = credentials.phoneNumber;
      displayName = credentials.displayName;
    } else {
      // Direct parsing fallback (e.g. for testing / dev tokens formatted as "uid:phone:name")
      final parts = firebaseIdToken.split(':');
      firebaseUid = parts.isNotEmpty ? parts[0] : firebaseIdToken;
      phoneNumber = parts.length > 1 ? parts[1] : '+1234567890';
      displayName = parts.length > 2 ? parts[2] : null;
    }

    final appUser = await client.auth.authenticateWithFirebasePhone(
      firebaseUid: firebaseUid,
      phoneNumber: phoneNumber,
      displayName: displayName,
    );

    final user = _mapAppUserToDomain(appUser);
    _currentUser = user;
    await storage.saveUser(_mapDomainToUserCM(user));
    _userController.add(user);

    return user;
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (_) {}

    await storage.clearUser();
    _currentUser = null;
    _userController.add(null);
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

  User _mapUserCMToDomain(UserCM cm) {
    return User(
      id: UserId(cm.id),
      phoneNumber: PhoneNumber.parse(cm.phoneNumber),
      displayName: cm.displayName,
      bio: cm.bio,
      photoUrl: cm.photoUrl,
      notificationsEnabled: cm.notificationsEnabled,
      lastSeenAt:
          cm.lastSeenAt != null ? DateTime.tryParse(cm.lastSeenAt!) : null,
      createdAt: DateTime.parse(cm.createdAt),
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

  void dispose() {
    _userController.close();
  }
}
