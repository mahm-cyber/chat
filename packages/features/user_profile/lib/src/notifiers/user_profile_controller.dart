import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_profile_state.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  throw UnimplementedError('userRepositoryProvider must be overridden');
});

final userProfileControllerProvider = StateNotifierProvider.autoDispose
    .family<UserProfileController, UserProfileState, UserId?>((ref, userId) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserProfileController(
    userRepository: userRepository,
    userId: userId,
  );
});

class UserProfileController extends StateNotifier<UserProfileState> {
  final IUserRepository userRepository;
  final UserId? userId;

  UserProfileController({
    required this.userRepository,
    this.userId,
  }) : super(const UserProfileState(isLoading: true)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final targetId = userId ?? UserId('me');
      final user = await userRepository.getUser(targetId);
      state = state.copyWith(
        isLoading: false,
        user: user,
        displayName: user.displayName,
        bio: user.bio ?? '',
        avatarUrl: user.avatarUrl,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: 'common.error',
      );
    }
  }

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name, isSaved: false, clearError: true);
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio, isSaved: false, clearError: true);
  }

  void setAvatarUrl(String url) {
    state = state.copyWith(avatarUrl: url, isSaved: false, clearError: true);
  }

  Future<bool> saveChanges() async {
    final name = state.displayName.trim();
    if (name.isEmpty) {
      state = state.copyWith(errorMessageKey: 'common.error');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final updated = await userRepository.updateProfile(
        displayName: name,
        bio: state.bio.trim().isEmpty ? null : state.bio.trim(),
        photoUrl: state.avatarUrl,
      );
      state = state.copyWith(
        isSaving: false,
        isSaved: true,
        user: updated,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessageKey: 'common.error',
      );
      return false;
    }
  }
}
