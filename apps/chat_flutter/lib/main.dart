import 'package:auth_repository/auth_repository.dart';
import 'package:chat_client/chat_client.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:localization_repository/localization_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'app_router.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = KeyValueStorage();
  final client = Client('http://localhost:8080/');

  final authRepo = AuthRepository(client: client, storage: storage);
  final chatRepo = ChatRepository(client: client, storage: storage);
  final userRepo = UserRepository(client: client, storage: storage);
  final locRepo = LocalizationRepository(client: client, storage: storage);

  await authRepo.initialize();
  await locRepo.initialize(initialLocale: 'en');

  // Preload initial English translations
  Map<String, String> initialTranslations = {
    'auth.welcome_back': 'Welcome to Chat',
    'auth.sign_in': 'Sign In',
    'auth.enter_phone': 'Enter your phone number',
    'auth.phone_placeholder': '+1 234 567 8900',
    'auth.send_otp': 'Send Verification Code',
    'auth.verify_code': 'Verify Code',
    'auth.otp_sent_to': 'We sent a verification code to {phone}',
    'auth.change_phone': 'Change phone number',
    'auth.resend_code': 'Resend Code',
    'auth.enter_valid_phone': 'Please enter a valid phone number',
    'auth.enter_valid_code': 'Please enter a 6-digit code',
    'conversations.title': 'Messages',
    'conversations.empty_state': 'No messages yet. Start a new conversation!',
    'conversations.new_chat': 'New Chat',
    'conversations.search_hint': 'Search conversations...',
    'chat.type_message': 'Type a message...',
    'chat.send': 'Send',
    'chat.typing': 'typing...',
    'profile.title': 'Profile',
    'profile.display_name': 'Display Name',
    'profile.bio': 'Bio',
    'profile.save': 'Save Changes',
    'settings.title': 'Settings',
    'settings.theme_mode': 'Theme Mode',
    'settings.theme_system': 'System',
    'settings.theme_light': 'Light',
    'settings.theme_dark': 'Dark',
    'settings.notifications': 'Notifications',
    'settings.logout': 'Sign Out',
    'contacts.title': 'New Conversation',
    'contacts.search_hint': 'Search contacts...',
    'contacts.sync_contacts': 'Sync Contacts',
    'contacts.no_contacts': 'No contacts found',
    'common.error': 'An error occurred. Please try again.',
    'common.cancel': 'Cancel',
    'common.confirm': 'Confirm',
  };

  if (locRepo.currentTranslations.isNotEmpty) {
    initialTranslations.addAll(locRepo.currentTranslations);
  }

  final cachedUser = await storage.getUser();
  final isAuthenticated = cachedUser != null;
  final currentUserId =
      cachedUser != null ? UserId(cachedUser.id.toString()) : UserId('guest');

  runApp(
    ProviderScope(
      overrides: createRepositoryOverrides(
        storage: storage,
        client: client,
        authRepository: authRepo,
        chatRepository: chatRepo,
        userRepository: userRepo,
        localizationRepository: locRepo,
        currentUserId: currentUserId,
      ),
      child: ChatLocalizationsScope(
        repository: locRepo,
        translations: initialTranslations,
        child: ChatApp(
          isAuthenticated: isAuthenticated,
          currentUserId: currentUserId,
        ),
      ),
    ),
  );
}

class ChatApp extends ConsumerWidget {
  final bool isAuthenticated;
  final UserId currentUserId;

  const ChatApp({
    super.key,
    required this.isAuthenticated,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = createRouter(
      isAuthenticated: isAuthenticated,
      currentUserId: currentUserId,
    );

    return MaterialApp.router(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ChatThemeData.light(),
      darkTheme: ChatThemeData.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
