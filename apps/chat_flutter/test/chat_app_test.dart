import 'dart:async';
import 'package:auth/auth.dart' as auth_feature;
import 'package:chat_flutter/main.dart';
import 'package:chat_room/chat_room.dart' as chat_room_feature;
import 'package:component_library/component_library.dart';
import 'package:contact_picker/contact_picker.dart' as contact_picker_feature;
import 'package:conversation_list/conversation_list.dart' as conv_feature;
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/settings.dart' as settings_feature;
import 'package:user_profile/user_profile.dart' as user_profile_feature;

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockChatRepository extends Mock implements IChatRepository {}
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockChatRepository mockChatRepository;
  late MockUserRepository mockUserRepository;
  late StreamController<List<Conversation>> conversationsController;

  final sampleTranslations = {
    'auth.welcome_back': 'Welcome to Chat',
    'auth.sign_in': 'Sign In',
    'auth.enter_phone': 'Enter your phone number',
    'auth.phone_placeholder': '+1 234 567 8900',
    'auth.send_otp': 'Send Verification Code',
    'conversations.title': 'Messages',
    'conversations.empty_state': 'No messages yet. Start a new conversation!',
    'conversations.new_chat': 'New Chat',
    'conversations.search_hint': 'Search conversations...',
  };

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockChatRepository = MockChatRepository();
    mockUserRepository = MockUserRepository();
    conversationsController = StreamController<List<Conversation>>.broadcast();

    when(() => mockAuthRepository.watchCurrentUser())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockChatRepository.watchConversations())
        .thenAnswer((_) => conversationsController.stream);
  });

  tearDown(() async {
    await conversationsController.close();
  });

  Widget buildTestApp({
    required bool isAuthenticated,
    required UserId currentUserId,
  }) {
    return ProviderScope(
      overrides: [
        auth_feature.authRepositoryProvider.overrideWithValue(mockAuthRepository),
        conv_feature.chatRepositoryProvider.overrideWithValue(mockChatRepository),
        conv_feature.currentUserIdProvider.overrideWithValue(currentUserId),
        chat_room_feature.chatRepositoryProvider.overrideWithValue(mockChatRepository),
        chat_room_feature.currentUserIdProvider.overrideWithValue(currentUserId),
        settings_feature.authRepositoryProvider.overrideWithValue(mockAuthRepository),
        settings_feature.userRepositoryProvider.overrideWithValue(mockUserRepository),
        user_profile_feature.userRepositoryProvider.overrideWithValue(mockUserRepository),
        contact_picker_feature.userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
      child: ChatLocalizationsScope(
        translations: sampleTranslations,
        child: ChatApp(
          isAuthenticated: isAuthenticated,
          currentUserId: currentUserId,
        ),
      ),
    );
  }

  testWidgets('renders AuthScreen when not authenticated', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        isAuthenticated: false,
        currentUserId: UserId('guest'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key(auth_feature.AuthTestIds.phoneInput)), findsOneWidget);
    expect(find.byKey(const Key(auth_feature.AuthTestIds.sendOtpButton)), findsOneWidget);
  });

  testWidgets('renders ConversationListScreen when authenticated', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        isAuthenticated: true,
        currentUserId: UserId('user-1'),
      ),
    );
    conversationsController.add([]);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key(conv_feature.ConversationListTestIds.searchInput)), findsOneWidget);
    expect(find.byKey(const Key(conv_feature.ConversationListTestIds.newChatButton)), findsOneWidget);
  });
}
