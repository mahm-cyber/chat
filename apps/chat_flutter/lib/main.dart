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
  try {
    await locRepo.syncTranslations('en');
  } catch (_) {}

  // Preload initial English translations matching LocalizationEndpoint
  final Map<String, String> initialTranslations = {
    'auth.welcome_title': 'Welcome to Chat',
    'auth.phone_subtitle': 'Enter your phone number to sign in or create an account',
    'auth.phone_label': 'Phone Number',
    'auth.send_code_button': 'Continue',
    'auth.verify_title': 'Verify Code',
    'auth.verify_subtitle': 'Enter the 6-digit code sent to your phone',
    'auth.resend_code': 'Resend Code',
    'auth.change_phone': 'Change phone number',
    'auth.enter_valid_phone': 'Please enter a valid phone number',
    'auth.enter_valid_code': 'Please enter a 6-digit code',
    'chat.conversations_title': 'Chats',
    'chat.empty_conversations': 'No conversations yet. Start a new chat!',
    'chat.new_chat_button': 'New Chat',
    'chat.search_placeholder': 'Search conversations or users...',
    'chat.message_input_placeholder': 'Type a message...',
    'chat.send_button': 'Send',
    'chat.status_online': 'Online',
    'chat.status_offline': 'Offline',
    'chat.typing': 'typing...',
    'profile.title': 'Profile',
    'profile.display_name_label': 'Display Name',
    'profile.bio_label': 'Status / Bio',
    'profile.save_button': 'Save Changes',
    'profile.change_photo': 'Change Photo',
    'profile.my_qr_code': 'My QR Code',
    'settings.title': 'Settings',
    'settings.theme_label': 'Appearance',
    'settings.theme_system': 'System Default',
    'settings.theme_light': 'Light Mode',
    'settings.theme_dark': 'Dark Mode',
    'settings.notifications_label': 'Notifications',
    'settings.notifications_subtitle': 'Receive alerts for new messages',
    'settings.logout_button': 'Log Out',
    'contacts.title': 'Contacts',
    'contacts.search_placeholder': 'Search contacts...',
    'contacts.sync_button': 'Sync Contacts',
    'contacts.invite_button': 'Invite Friends',
    'contacts.empty': 'No contacts found',
    'common.error': 'Something went wrong',
    'common.save': 'Save',
    'common.cancel': 'Cancel',
    'common.confirm': 'Confirm',
    'common.search': 'Search',
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
