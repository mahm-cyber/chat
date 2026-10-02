import 'package:auth/auth.dart' as auth_feature;
import 'package:auth_repository/auth_repository.dart';
import 'package:chat_client/chat_client.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_room/chat_room.dart' as chat_room_feature;
import 'package:contact_picker/contact_picker.dart' as contact_picker_feature;
import 'package:conversation_list/conversation_list.dart' as conv_feature;
import 'package:domain_models/domain_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:localization_repository/localization_repository.dart';
import 'package:settings/settings.dart' as settings_feature;
import 'package:user_profile/user_profile.dart' as user_profile_feature;
import 'package:user_repository/user_repository.dart';

final keyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  throw UnimplementedError('keyValueStorageProvider must be overridden');
});

final serverpodClientProvider = Provider<Client>((ref) {
  throw UnimplementedError('serverpodClientProvider must be overridden');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final storage = ref.watch(keyValueStorageProvider);
  return AuthRepository(client: client, storage: storage);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final storage = ref.watch(keyValueStorageProvider);
  return ChatRepository(client: client, storage: storage);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final storage = ref.watch(keyValueStorageProvider);
  return UserRepository(client: client, storage: storage);
});

final localizationRepositoryProvider = Provider<LocalizationRepository>((ref) {
  final client = ref.watch(serverpodClientProvider);
  final storage = ref.watch(keyValueStorageProvider);
  return LocalizationRepository(client: client, storage: storage);
});

final currentUserStreamProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.watchCurrentUser();
});

final currentUserIdProvider = Provider<UserId>((ref) {
  final userAsync = ref.watch(currentUserStreamProvider);
  return userAsync.value?.id ?? UserId('guest');
});

List<Override> createRepositoryOverrides({
  required KeyValueStorage storage,
  required Client client,
  required AuthRepository authRepository,
  required ChatRepository chatRepository,
  required UserRepository userRepository,
  required LocalizationRepository localizationRepository,
  required UserId currentUserId,
}) {
  return [
    keyValueStorageProvider.overrideWithValue(storage),
    serverpodClientProvider.overrideWithValue(client),
    authRepositoryProvider.overrideWithValue(authRepository),
    chatRepositoryProvider.overrideWithValue(chatRepository),
    userRepositoryProvider.overrideWithValue(userRepository),
    localizationRepositoryProvider.overrideWithValue(localizationRepository),
    auth_feature.authRepositoryProvider.overrideWithValue(authRepository),
    conv_feature.chatRepositoryProvider.overrideWithValue(chatRepository),
    conv_feature.currentUserIdProvider.overrideWithValue(currentUserId),
    chat_room_feature.chatRepositoryProvider.overrideWithValue(chatRepository),
    chat_room_feature.currentUserIdProvider.overrideWithValue(currentUserId),
    settings_feature.authRepositoryProvider.overrideWithValue(authRepository),
    settings_feature.userRepositoryProvider.overrideWithValue(userRepository),
    user_profile_feature.userRepositoryProvider.overrideWithValue(userRepository),
    contact_picker_feature.userRepositoryProvider.overrideWithValue(userRepository),
  ];
}
