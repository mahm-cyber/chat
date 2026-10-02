class WebTranslations {
  static final Map<String, String> _translations = {
    'conversations.title': 'Messages',
    'conversations.empty_state': 'No messages yet. Start a new conversation!',
    'conversations.new_chat': 'New Chat',
    'conversations.search_hint': 'Search conversations...',
    'chat.type_message': 'Type a message...',
    'chat.send': 'Send',
    'chat.typing': 'typing...',
    'profile.title': 'Profile',
    'profile.display_name': 'Display Name',
    'settings.title': 'Settings',
    'settings.theme_mode': 'Theme Mode',
    'settings.theme_dark': 'Dark Mode',
    'settings.theme_light': 'Light Mode',
    'settings.logout': 'Sign Out',
    'common.error': 'An error occurred. Please try again.',
  };

  static String tr(String key) {
    return _translations[key] ?? key;
  }

  static void loadTranslations(Map<String, String> newTranslations) {
    _translations.addAll(newTranslations);
  }
}

String localize(String key) => WebTranslations.tr(key);
