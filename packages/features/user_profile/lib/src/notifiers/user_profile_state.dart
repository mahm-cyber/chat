import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable {
  final User? user;
  final String displayName;
  final String bio;
  final String? avatarUrl;
  final bool isLoading;
  final bool isSaving;
  final bool isSaved;
  final String? errorMessageKey;

  const UserProfileState({
    this.user,
    this.displayName = '',
    this.bio = '',
    this.avatarUrl,
    this.isLoading = false,
    this.isSaving = false,
    this.isSaved = false,
    this.errorMessageKey,
  });

  UserProfileState copyWith({
    User? user,
    String? displayName,
    String? bio,
    String? avatarUrl,
    bool? isLoading,
    bool? isSaving,
    bool? isSaved,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }

  @override
  List<Object?> get props => [
        user,
        displayName,
        bio,
        avatarUrl,
        isLoading,
        isSaving,
        isSaved,
        errorMessageKey,
      ];
}
