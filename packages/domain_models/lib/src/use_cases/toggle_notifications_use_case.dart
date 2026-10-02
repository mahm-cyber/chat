import '../entities/user.dart';
import '../repositories/i_user_repository.dart';

class ToggleNotificationsUseCase {
  final IUserRepository _userRepository;

  const ToggleNotificationsUseCase(this._userRepository);

  Future<User> execute(bool enabled) {
    return _userRepository.toggleNotifications(enabled);
  }
}
