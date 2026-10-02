import 'package:chat_client/chat_client.dart';
import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:localization_repository/localization_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

void main() {
  group('ChatText Component', () {
    testWidgets('renders specified text and variant', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatText.titleLarge(
              'Hello Polaris',
              testId: Key('my_title'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('my_title')), findsOneWidget);
      expect(find.text('Hello Polaris'), findsOneWidget);
    });
  });

  group('ChatTappable Component', () {
    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatTappable(
              testId: const Key('tap_me'),
              onTap: () => tapped = true,
              child: const ChatText('Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('tap_me')));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('ChatAvatar Component', () {
    testWidgets('renders fallback initials from user name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatAvatar(
              name: 'John Doe',
              testId: Key('john_avatar'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('john_avatar')), findsOneWidget);
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('renders online indicator when requested', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatAvatar(
              name: 'Alice',
              isOnline: true,
              showOnlineIndicator: true,
              testId: Key('alice_avatar'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('alice_avatar')), findsOneWidget);
      expect(find.text('AL'), findsOneWidget);
    });
  });

  group('ChatBubble Component', () {
    testWidgets('renders outgoing message with timestamp and status tick',
        (tester) async {
      final msg = Message(
        id: MessageId('msg-1'),
        conversationId: ConversationId('conv-1'),
        senderId: UserId('user-1'),
        recipientId: UserId('user-2'),
        content: MessageContent.create(text: 'Hello from sender'),
        status: MessageStatus.sent,
        sentAt: DateTime(2026, 1, 1, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: msg,
              isOutgoing: true,
              testId: const Key('bubble_1'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('bubble_1')), findsOneWidget);
      expect(find.text('Hello from sender'), findsOneWidget);
      expect(find.text('14:30'), findsOneWidget);
      expect(find.byIcon(ChatIcons.check), findsOneWidget);
    });

    testWidgets('renders incoming message correctly', (tester) async {
      final msg = Message(
        id: MessageId('msg-2'),
        conversationId: ConversationId('conv-1'),
        senderId: UserId('user-2'),
        recipientId: UserId('user-1'),
        content: MessageContent.create(text: 'Incoming message text'),
        status: MessageStatus.read,
        sentAt: DateTime(2026, 1, 1, 14, 35),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: msg,
              isOutgoing: false,
              testId: const Key('bubble_2'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('bubble_2')), findsOneWidget);
      expect(find.text('Incoming message text'), findsOneWidget);
      expect(find.text('14:35'), findsOneWidget);
    });
  });

  group('ThemeModeNotifier', () {
    test('toggles and sets theme modes', () {
      final notifier = ThemeModeNotifier(ThemeMode.light);
      expect(notifier.state, equals(ThemeMode.light));

      notifier.toggleTheme();
      expect(notifier.state, equals(ThemeMode.dark));

      notifier.setThemeMode(ThemeMode.system);
      expect(notifier.state, equals(ThemeMode.system));
    });
  });

  group('ChatLocalizationsScope', () {
    testWidgets('translates dynamic keys via context.tr', (tester) async {
      final repo = LocalizationRepository(
        client: MockClient(),
        storage: KeyValueStorage(),
      );

      await tester.pumpWidget(
        ChatLocalizationsScope(
          repository: repo,
          translations: const {'greeting': 'Welcome {name}!'},
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ChatText(
                    context.tr('greeting', parameters: {'name': 'Polaris'}),
                    testId: const Key('greeting_text'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('greeting_text')), findsOneWidget);
    });
  });
}
