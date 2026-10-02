import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_state.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  throw UnimplementedError('userRepositoryProvider must be overridden');
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider must be overridden');
});

final settingsControllerProvider =
    StateNotifierProvider.autoDispose<SettingsController, SettingsState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return SettingsController(
    userRepository: userRepository,
    authRepository: authRepository,
  );
});

class SettingsController extends StateNotifier<SettingsState> {
  final IUserRepository userRepository;
  final IAuthRepository authRepository;

  SettingsController({
    required this.userRepository,
    required this.authRepository,
  }) : super(const SettingsState());

  Future<void> toggleNotifications() async {
    final next = !state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: next);
    try {
      await userRepository.toggleNotifications(next);
    } catch (_) {
      // Revert on failure
      state = state.copyWith(
        notificationsEnabled: !next,
        errorMessageKey: 'common.error',
      );
    }
  }

  Future<bool> logout() async {
    state = state.copyWith(isLoggingOut: true);
    try {
      await authRepository.signOut();
      state = state.copyWith(isLoggingOut: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoggingOut: false,
        errorMessageKey: 'common.error',
      );
      return false;
    }
  }
}
