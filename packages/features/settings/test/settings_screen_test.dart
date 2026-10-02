import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/settings.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;

  final testUser = User(
    id: UserId('user-1'),
    phoneNumber: PhoneNumber.parse('+15551234567'),
    displayName: 'Test User',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();

    when(() => mockUserRepository.toggleNotifications(any()))
        .thenAnswer((_) async => testUser);
    when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget({
    required VoidCallback onBack,
    required VoidCallback onLoggedOut,
  }) {
    return ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        home: SettingsScreen(
          onBack: onBack,
          onLoggedOut: onLoggedOut,
        ),
      ),
    );
  }

  testWidgets('switches theme and toggles notifications', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        onBack: () {},
        onLoggedOut: () {},
      ),
    );
    await tester.pumpAndSettle();

    // Tap dark mode
    await tester.tap(find.byKey(const Key(SettingsTestIds.themeDark)));
    await tester.pumpAndSettle();

    // Toggle notifications
    await tester.tap(find.byKey(const Key(SettingsTestIds.notificationToggle)));
    await tester.pumpAndSettle();

    verify(() => mockUserRepository.toggleNotifications(false)).called(1);
  });

  testWidgets('logout button signs out and triggers onLoggedOut',
      (tester) async {
    var loggedOut = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onBack: () {},
        onLoggedOut: () => loggedOut = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key(SettingsTestIds.logoutButton)));
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.signOut()).called(1);
    expect(loggedOut, isTrue);
  });
}
