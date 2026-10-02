import 'package:contact_picker/contact_picker.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  final testUser = User(
    id: UserId('user-bob'),
    phoneNumber: PhoneNumber.parse('+15551112233'),
    displayName: 'Bob Builder',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    when(() => mockUserRepository.searchUsers(any()))
        .thenAnswer((_) async => [testUser]);
    when(() => mockUserRepository.syncContacts(any()))
        .thenAnswer((_) async => [testUser]);
  });

  Widget buildTestableWidget({
    required void Function(User) onSelectUser,
    required VoidCallback onBack,
  }) {
    return ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
      child: MaterialApp(
        home: ContactPickerScreen(
          onSelectUser: onSelectUser,
          onBack: onBack,
        ),
      ),
    );
  }

  testWidgets('renders search results and triggers onSelectUser',
      (tester) async {
    User? selected;

    await tester.pumpWidget(
      buildTestableWidget(
        onSelectUser: (u) => selected = u,
        onBack: () {},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bob Builder'), findsOneWidget);
    expect(find.text('+15551112233'), findsOneWidget);

    await tester.tap(
        find.byKey(Key(ContactPickerTestIds.contactItem('user-bob'))));
    await tester.pumpAndSettle();

    expect(selected, equals(testUser));
  });

  testWidgets('sync contacts button triggers syncContacts', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        onSelectUser: (_) {},
        onBack: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
        find.byKey(const Key(ContactPickerTestIds.syncContactsButton)));
    await tester.pumpAndSettle();

    verify(() => mockUserRepository.syncContacts(any())).called(1);
  });
}
