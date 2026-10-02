import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'contact_picker_state.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  throw UnimplementedError('userRepositoryProvider must be overridden');
});

final contactPickerControllerProvider = StateNotifierProvider.autoDispose<
    ContactPickerController, ContactPickerState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return ContactPickerController(userRepository: userRepository);
});

class ContactPickerController extends StateNotifier<ContactPickerState> {
  final IUserRepository userRepository;

  ContactPickerController({required this.userRepository})
      : super(const ContactPickerState(isLoading: true)) {
    search('');
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true, clearError: true);
    try {
      final results = await userRepository.searchUsers(query);
      state = state.copyWith(
        isLoading: false,
        users: results,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: 'common.error',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    search(query);
  }

  Future<void> syncDeviceContacts(List<String> phoneNumbers) async {
    state = state.copyWith(isSyncing: true, clearError: true);
    try {
      final phoneList =
          phoneNumbers.map((p) => PhoneNumber.parse(p)).toList();
      final matched = await userRepository.syncContacts(phoneList);
      state = state.copyWith(
        isSyncing: false,
        users: matched,
      );
    } catch (_) {
      state = state.copyWith(
        isSyncing: false,
        errorMessageKey: 'common.error',
      );
    }
  }
}
