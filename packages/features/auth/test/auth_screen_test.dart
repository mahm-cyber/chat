import 'package:auth/auth.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget buildTestableWidget({
    required VoidCallback onAuthenticated,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        home: AuthScreen(
          onAuthenticated: onAuthenticated,
        ),
      ),
    );
  }

  testWidgets('AuthScreen phone input flow moves to OTP step', (tester) async {
    when(() => mockAuthRepository.sendOtpCode(PhoneNumber.parse('+15551234567')))
        .thenAnswer((_) async => 'verification-123');

    var authenticated = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onAuthenticated: () => authenticated = true,
      ),
    );

    expect(find.byKey(const Key(AuthTestIds.phoneInput)), findsOneWidget);
    expect(find.byKey(const Key(AuthTestIds.sendOtpButton)), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key(AuthTestIds.phoneInput)),
      '+15551234567',
    );
    await tester.tap(find.byKey(const Key(AuthTestIds.sendOtpButton)));
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.sendOtpCode(PhoneNumber.parse('+15551234567'))).called(1);
    expect(find.byKey(const Key(AuthTestIds.otpInput)), findsOneWidget);
    expect(find.byKey(const Key(AuthTestIds.verifyOtpButton)), findsOneWidget);
    expect(authenticated, isFalse);
  });

  testWidgets('AuthScreen OTP step verifies code and triggers onAuthenticated',
      (tester) async {
    when(() => mockAuthRepository.sendOtpCode(PhoneNumber.parse('+15551234567')))
        .thenAnswer((_) async => 'verification-123');

    final testUser = User(
      id: UserId('user-1'),
      phoneNumber: PhoneNumber.parse('+15551234567'),
      displayName: 'Test User',
      createdAt: DateTime.now(),
    );

    when(() => mockAuthRepository.verifySmsCode(
          verificationId: 'verification-123',
          smsCode: '123456',
        )).thenAnswer((_) async => testUser);

    var authenticated = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onAuthenticated: () => authenticated = true,
      ),
    );

    // 1. Enter phone and send
    await tester.enterText(
      find.byKey(const Key(AuthTestIds.phoneInput)),
      '+15551234567',
    );
    await tester.tap(find.byKey(const Key(AuthTestIds.sendOtpButton)));
    await tester.pumpAndSettle();

    // 2. Enter OTP and verify
    await tester.enterText(
      find.byKey(const Key(AuthTestIds.otpInput)),
      '123456',
    );
    await tester.tap(find.byKey(const Key(AuthTestIds.verifyOtpButton)));
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.verifySmsCode(
          verificationId: 'verification-123',
          smsCode: '123456',
        )).called(1);

    expect(authenticated, isTrue);
  });
}
