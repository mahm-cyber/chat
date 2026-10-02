import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

enum AuthStep { phone, otp }

class AuthState extends Equatable {
  final AuthStep step;
  final String phoneNumber;
  final String? verificationId;
  final bool isLoading;
  final String? errorMessageKey;
  final User? user;

  const AuthState({
    this.step = AuthStep.phone,
    this.phoneNumber = '',
    this.verificationId,
    this.isLoading = false,
    this.errorMessageKey,
    this.user,
  });

  AuthState copyWith({
    AuthStep? step,
    String? phoneNumber,
    String? verificationId,
    bool? isLoading,
    String? errorMessageKey,
    bool clearError = false,
    User? user,
  }) {
    return AuthState(
      step: step ?? this.step,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      isLoading: isLoading ?? this.isLoading,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        step,
        phoneNumber,
        verificationId,
        isLoading,
        errorMessageKey,
        user,
      ];
}
