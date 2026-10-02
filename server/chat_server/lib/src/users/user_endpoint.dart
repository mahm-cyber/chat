import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  /// Fetches a user profile by ID
  Future<AppUser?> getProfile(Session session, int userId) async {
    return await AppUser.db.findById(session, userId);
  }

  /// Updates profile details (display name, bio, photo URL)
  Future<AppUser?> updateProfile(
    Session session, {
    required int userId,
    String? displayName,
    String? bio,
    String? photoUrl,
  }) async {
    final user = await AppUser.db.findById(session, userId);
    if (user == null) return null;

    if (displayName != null && displayName.trim().isNotEmpty) {
      user.displayName = displayName.trim();
    }
    if (bio != null) {
      user.bio = bio.trim();
    }
    if (photoUrl != null) {
      user.photoUrl = photoUrl;
    }

    return await AppUser.db.updateRow(session, user);
  }

  /// Toggles push notifications setting
  Future<AppUser?> toggleNotifications(
    Session session, {
    required int userId,
    required bool enabled,
  }) async {
    final user = await AppUser.db.findById(session, userId);
    if (user == null) return null;

    user.notificationsEnabled = enabled;
    return await AppUser.db.updateRow(session, user);
  }

  /// Searches for registered users by phone number or display name
  Future<List<AppUser>> searchUsers(Session session, String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    return await AppUser.db.find(
      session,
      where: (t) =>
          t.displayName.like('%$cleanQuery%') |
          t.phoneNumber.like('%$cleanQuery%'),
      limit: 30,
    );
  }

  /// Matches device contacts (phone numbers) against registered users
  Future<List<AppUser>> syncContacts(
    Session session,
    List<String> phoneNumbers,
  ) async {
    if (phoneNumbers.isEmpty) return [];

    final cleanNumbers = phoneNumbers
        .map((p) => p.replaceAll(RegExp(r'[\s\-()]'), ''))
        .where((p) => p.isNotEmpty)
        .toSet()
        .toList();

    return await AppUser.db.find(
      session,
      where: (t) => t.phoneNumber.inSet(cleanNumbers.toSet()),
    );
  }

  /// Returns a secure upload description path for uploading an avatar photo
  Future<String?> getAvatarUploadDescription(Session session, String fileName) async {
    final path = 'avatars/${session.server.serverId}_${DateTime.now().millisecondsSinceEpoch}_$fileName';
    try {
      return await session.storage.createUploadDescription(
        storageId: 'public',
        path: path,
      );
    } catch (_) {
      return 'local_mock_description:$path';
    }
  }

  /// Resolves the public URL for a given storage path
  Future<String> getPublicAvatarUrl(Session session, String path) async {
    try {
      final uri = await session.storage.publicDownloadUrl(
        storageId: 'public',
        path: path,
      );
      return uri.toString();
    } catch (_) {
      return path;
    }
  }
}
