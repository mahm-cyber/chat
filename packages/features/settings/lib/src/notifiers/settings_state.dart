import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool isLoading;
  final bool isLoggingOut;
  final String? errorMessageKey;

  const SettingsState({
    this.notificationsEnabled = true,
    this.isLoading = false,
    this.isLoggingOut = false,
    this.errorMessageKey,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? isLoading,
    bool? isLoggingOut,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return SettingsState(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      isLoading: isLoading ?? this.isLoading,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        isLoading,
        isLoggingOut,
        errorMessageKey,
      ];
}
