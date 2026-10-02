import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_profile/user_profile.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  final testUserId = UserId('user-test-1');

  final testUser = User(
    id: testUserId,
    phoneNumber: PhoneNumber.parse('+15551234567'),
    displayName: 'Original Name',
    bio: 'Original bio description',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    when(() => mockUserRepository.getUser(testUserId))
        .thenAnswer((_) async => testUser);
  });

  Widget buildTestableWidget({
    required VoidCallback onBack,
  }) {
    return ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
      child: MaterialApp(
        home: UserProfileScreen(
          userId: testUserId,
          onBack: onBack,
        ),
      ),
    );
  }

  testWidgets('renders profile fields and updates on save', (tester) async {
    when(() => mockUserRepository.updateProfile(
          displayName: 'Updated Name',
          bio: 'Updated Bio',
          photoUrl: any(named: 'photoUrl'),
        )).thenAnswer((_) async => testUser.copyWith(
          displayName: 'Updated Name',
          bio: 'Updated Bio',
        ));

    await tester.pumpWidget(
      buildTestableWidget(onBack: () {}),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key(UserProfileTestIds.nameInput)), findsOneWidget);
    expect(find.byKey(const Key(UserProfileTestIds.bioInput)), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key(UserProfileTestIds.nameInput)),
      'Updated Name',
    );
    await tester.enterText(
      find.byKey(const Key(UserProfileTestIds.bioInput)),
      'Updated Bio',
    );

    await tester.tap(find.byKey(const Key(UserProfileTestIds.saveButton)));
    await tester.pumpAndSettle();

    verify(() => mockUserRepository.updateProfile(
          displayName: 'Updated Name',
          bio: 'Updated Bio',
          photoUrl: any(named: 'photoUrl'),
        )).called(1);
  });

  testWidgets('opens QR dialog and handles back callback', (tester) async {
    var backPressed = false;

    await tester.pumpWidget(
      buildTestableWidget(onBack: () => backPressed = true),
    );

    await tester.pumpAndSettle();

    // Open QR Code Dialog
    await tester.tap(find.byKey(const Key(UserProfileTestIds.qrCodeButton)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key(UserProfileTestIds.qrDialog)), findsOneWidget);

    // Close Dialog
    await tester.tap(find.byKey(const Key('profile.close_qr_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key(UserProfileTestIds.qrDialog)), findsNothing);

    // Back button
    await tester.tap(find.byKey(const Key(UserProfileTestIds.backButton)));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });
}
