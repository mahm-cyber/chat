import '../entities/user.dart';
import '../repositories/i_user_repository.dart';

class UpdateProfileUseCase {
  final IUserRepository _userRepository;

  const UpdateProfileUseCase(this._userRepository);

  Future<User> execute({
    String? displayName,
    String? bio,
    String? photoUrl,
  }) {
    return _userRepository.updateProfile(
      displayName: displayName,
      bio: bio,
      photoUrl: photoUrl,
    );
  }
}
