import 'dart:convert';
import 'models/conversation_cm.dart';
import 'models/message_cm.dart';
import 'models/user_cm.dart';

class KeyValueStorage {
  final Map<String, String> _storage = {};

  // User & Auth
  Future<void> saveUser(UserCM user) async {
    _storage['auth_user'] = jsonEncode(user.toJson());
  }

  Future<UserCM?> getUser() async {
    final raw = _storage['auth_user'];
    if (raw == null) return null;
    try {
      return UserCM.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    _storage.remove('auth_user');
  }

  // Conversations
  Future<void> saveConversations(List<ConversationCM> conversations) async {
    _storage['conversations'] =
        jsonEncode(conversations.map((c) => c.toJson()).toList());
  }

  Future<List<ConversationCM>> getConversations() async {
    final raw = _storage['conversations'];
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => ConversationCM.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Messages per conversation
  Future<void> saveMessages(String conversationId, List<MessageCM> messages) async {
    _storage['messages_$conversationId'] =
        jsonEncode(messages.map((m) => m.toJson()).toList());
  }

  Future<List<MessageCM>> getMessages(String conversationId) async {
    final raw = _storage['messages_$conversationId'];
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => MessageCM.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Translations
  Future<void> saveTranslations(
    String locale,
    Map<String, String> translations,
    int version,
  ) async {
    _storage['translations_$locale'] = jsonEncode(translations);
    _storage['translations_version_$locale'] = version.toString();
  }

  Future<Map<String, String>?> getTranslations(String locale) async {
    final raw = _storage['translations_$locale'];
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return null;
    }
  }

  Future<int?> getTranslationVersion(String locale) async {
    final raw = _storage['translations_version_$locale'];
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  // Settings
  Future<void> saveThemeMode(String mode) async {
    _storage['settings_theme_mode'] = mode;
  }

  Future<String?> getThemeMode() async {
    return _storage['settings_theme_mode'];
  }

  Future<void> saveNotificationSetting(bool enabled) async {
    _storage['settings_notifications'] = enabled.toString();
  }

  Future<bool> getNotificationSetting() async {
    final raw = _storage['settings_notifications'];
    if (raw == null) return true;
    return raw == 'true';
  }

  Future<void> clearAll() async {
    _storage.clear();
  }
}
