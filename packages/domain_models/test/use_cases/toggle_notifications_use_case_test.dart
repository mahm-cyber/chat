import 'package:domain_models/domain_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepo;
  late ToggleNotificationsUseCase useCase;

  setUp(() {
    mockUserRepo = MockUserRepository();
    useCase = ToggleNotificationsUseCase(mockUserRepo);
  });

  test('delegates notification toggle to repository and returns updated user', () async {
    final originalUser = User(
      id: UserId('user_1'),
      phoneNumber: PhoneNumber.parse('+12025550143'),
      displayName: 'Alex',
      notificationsEnabled: true,
      createdAt: DateTime.now().toUtc(),
    );

    final updatedUser = originalUser.copyWith(notificationsEnabled: false);

    when(() => mockUserRepo.toggleNotifications(false))
        .thenAnswer((_) async => updatedUser);

    final result = await useCase.execute(false);

    expect(result.notificationsEnabled, isFalse);
    verify(() => mockUserRepo.toggleNotifications(false)).called(1);
  });
}
