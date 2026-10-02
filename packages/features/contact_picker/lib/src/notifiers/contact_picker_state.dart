import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class ContactPickerState extends Equatable {
  final List<User> users;
  final String searchQuery;
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessageKey;

  const ContactPickerState({
    this.users = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessageKey,
  });

  List<User> get filteredUsers {
    if (searchQuery.trim().isEmpty) return users;
    final query = searchQuery.trim().toLowerCase();
    return users.where((u) {
      return u.displayName.toLowerCase().contains(query) ||
          u.phoneNumber.value.contains(query);
    }).toList();
  }

  ContactPickerState copyWith({
    List<User>? users,
    String? searchQuery,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return ContactPickerState(
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }

  @override
  List<Object?> get props => [
        users,
        searchQuery,
        isLoading,
        isSyncing,
        errorMessageKey,
      ];
}
