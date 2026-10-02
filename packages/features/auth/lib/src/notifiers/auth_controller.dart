import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider must be overridden');
});

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController extends StateNotifier<AuthState> {
  final IAuthRepository authRepository;

  AuthController({required this.authRepository}) : super(const AuthState());

  void setPhoneNumber(String phone) {
    state = state.copyWith(phoneNumber: phone, clearError: true);
  }

  void changePhone() {
    state = state.copyWith(step: AuthStep.phone, clearError: true);
  }

  Future<bool> sendOtp() async {
    final rawPhone = state.phoneNumber.trim();
    if (rawPhone.isEmpty) {
      state = state.copyWith(errorMessageKey: 'auth.enter_valid_phone');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final sanitizedPhone =
          rawPhone.startsWith('+') ? rawPhone : '+$rawPhone';
      final phoneNumber = PhoneNumber.parse(sanitizedPhone);
      final verificationId = await authRepository.sendOtpCode(phoneNumber);
      state = state.copyWith(
        isLoading: false,
        step: AuthStep.otp,
        phoneNumber: sanitizedPhone,
        verificationId: verificationId,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: 'common.error',
      );
      return false;
    }
  }

  Future<User?> verifyOtp(String smsCode) async {
    if (smsCode.trim().length < 6) {
      state = state.copyWith(errorMessageKey: 'auth.enter_valid_code');
      return null;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final verificationId = state.verificationId ?? 'mock_verification_id';
      final user = await authRepository.verifySmsCode(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );
      state = state.copyWith(isLoading: false, user: user);
      return user;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: 'common.error',
      );
      return null;
    }
  }

  Future<bool> resendOtp() async {
    return sendOtp();
  }
}
