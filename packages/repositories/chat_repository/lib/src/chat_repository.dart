import 'dart:async';
import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

import 'mappers/cache_to_domain.dart';
import 'mappers/domain_to_cache.dart';
import 'mappers/remote_to_domain.dart';

class ChatRepository implements IChatRepository {
  final Client client;
  final KeyValueStorage storage;

  final StreamController<List<Conversation>> _conversationsController =
      StreamController<List<Conversation>>.broadcast();

  final Map<String, StreamController<List<Message>>> _messageControllers = {};
  final Map<String, List<Message>> _cachedMessages = {};
  final Map<String, StreamSubscription> _subscriptions = {};

  List<Conversation> _currentConversations = [];

  ChatRepository({
    required this.client,
    required this.storage,
  });

  @override
  Stream<List<Conversation>> watchConversations() async* {
    final currentUser = await _requireCurrentUser();

    // 1. Immediate local cache emission
    final cached = await storage.getConversations();
    if (cached.isNotEmpty) {
      _currentConversations = cached.map(mapCacheConversationToDomain).toList();
      yield _currentConversations;
    }

    // 2. Fetch fresh list from server
    unawaited(_refreshConversations(currentUser));

    yield* _conversationsController.stream;
  }

  Future<void> _refreshConversations(User currentUser) async {
    try {
      final currentIdInt = int.parse(currentUser.id.value);
      final remoteList = await client.chat.getConversations(currentIdInt);
      _currentConversations = remoteList
          .map((c) => mapRemoteConversationToDomain(
                c,
                currentUserId: currentUser.id,
              ))
          .toList();

      await storage.saveConversations(
        _currentConversations.map(mapDomainConversationToCache).toList(),
      );
      _conversationsController.add(_currentConversations);
    } catch (_) {
      // Offline fallback: keep cached conversations
    }
  }

  @override
  Stream<List<Message>> watchMessages(ConversationId conversationId) async* {
    final convIdStr = conversationId.value;
    final convIdInt = int.tryParse(convIdStr);
    final controller = _messageControllers.putIfAbsent(
      convIdStr,
      () => StreamController<List<Message>>.broadcast(),
    );

    // 1. Emit cached messages
    if (!_cachedMessages.containsKey(convIdStr)) {
      final cached = await storage.getMessages(convIdStr);
      _cachedMessages[convIdStr] =
          cached.map(mapCacheMessageToDomain).toList();
    }
    yield _cachedMessages[convIdStr] ?? [];

    // 2. Fetch server history and subscribe to real-time events
    if (convIdInt != null) {
      unawaited(_loadServerMessages(conversationId, convIdInt));
      _subscribeToRealtime(conversationId, convIdInt);
    }

    yield* controller.stream;
  }

  Future<void> _loadServerMessages(
    ConversationId conversationId,
    int convIdInt,
  ) async {
    try {
      final remote = await client.chat.getMessages(conversationId: convIdInt);
      final domainList = remote.map(mapRemoteMessageToDomain).toList();
      _cachedMessages[conversationId.value] = domainList;

      await storage.saveMessages(
        conversationId.value,
        domainList.map(mapDomainMessageToCache).toList(),
      );

      _messageControllers[conversationId.value]?.add(domainList);
    } catch (_) {
      // Offline fallback: keep local messages
    }
  }

  void _subscribeToRealtime(ConversationId conversationId, int convIdInt) {
    if (_subscriptions.containsKey(conversationId.value)) return;

    try {
      final stream = client.chat.watchConversation(convIdInt);
      final sub = stream.listen((event) {
        if (event.type == 'message' && event.message != null) {
          final newMsg = mapRemoteMessageToDomain(event.message!);
          final list = _cachedMessages[conversationId.value] ?? [];
          final existingIdx = list.indexWhere((m) => m.id == newMsg.id);
          if (existingIdx >= 0) {
            list[existingIdx] = newMsg;
          } else {
            list.add(newMsg);
          }
          _cachedMessages[conversationId.value] = list;
          storage.saveMessages(
            conversationId.value,
            list.map(mapDomainMessageToCache).toList(),
          );
          _messageControllers[conversationId.value]?.add(List.unmodifiable(list));
        }
      });
      _subscriptions[conversationId.value] = sub;
    } catch (_) {}
  }

  @override
  Future<Conversation> getOrCreateConversation(UserId recipientId) async {
    final currentUser = await _requireCurrentUser();
    final currentIdInt = int.parse(currentUser.id.value);
    final recipientIdInt = int.tryParse(recipientId.value);
    if (recipientIdInt == null) {
      throw DomainInvariantViolationException(
        'Invalid recipient ID: ${recipientId.value}',
      );
    }

    final model = await client.chat.getOrCreateConversation(
      currentUserId: currentIdInt,
      recipientId: recipientIdInt,
    );

    final domain = mapRemoteConversationToDomain(
      model,
      currentUserId: currentUser.id,
    );

    final idx = _currentConversations.indexWhere((c) => c.id == domain.id);
    if (idx >= 0) {
      _currentConversations[idx] = domain;
    } else {
      _currentConversations.insert(0, domain);
    }

    await storage.saveConversations(
      _currentConversations.map(mapDomainConversationToCache).toList(),
    );
    _conversationsController.add(List.unmodifiable(_currentConversations));

    return domain;
  }

  @override
  Future<Message> sendMessage({
    required ConversationId conversationId,
    required UserId recipientId,
    required MessageContent content,
  }) async {
    final currentUser = await _requireCurrentUser();
    final currentIdInt = int.parse(currentUser.id.value);
    final convIdInt = int.parse(conversationId.value);
    final recipientIdInt = int.parse(recipientId.value);

    final model = await client.chat.sendMessage(
      conversationId: convIdInt,
      senderId: currentIdInt,
      recipientId: recipientIdInt,
      content: content.text,
      attachmentUrls:
          content.attachments.isNotEmpty ? content.attachments : null,
    );

    final domainMsg = mapRemoteMessageToDomain(model);

    final list = _cachedMessages[conversationId.value] ?? [];
    list.add(domainMsg);
    _cachedMessages[conversationId.value] = list;

    await storage.saveMessages(
      conversationId.value,
      list.map(mapDomainMessageToCache).toList(),
    );
    _messageControllers[conversationId.value]?.add(List.unmodifiable(list));

    return domainMsg;
  }

  @override
  Future<void> markMessageDelivered(MessageId messageId) async {
    final currentUser = await _requireCurrentUser();
    final currentIdInt = int.parse(currentUser.id.value);
    final msgIdInt = int.tryParse(messageId.value);
    if (msgIdInt == null) return;

    final found = _findMessageById(messageId);
    final convIdInt = found != null
        ? int.tryParse(found.conversationId.value) ?? 0
        : 0;

    await client.chat.markMessageDelivered(
      messageId: msgIdInt,
      conversationId: convIdInt,
      senderId: currentIdInt,
    );
  }

  @override
  Future<void> markMessageRead(MessageId messageId) async {
    final currentUser = await _requireCurrentUser();
    final currentIdInt = int.parse(currentUser.id.value);
    final msgIdInt = int.tryParse(messageId.value);
    if (msgIdInt == null) return;

    final found = _findMessageById(messageId);
    final convIdInt = found != null
        ? int.tryParse(found.conversationId.value) ?? 0
        : 0;

    await client.chat.markMessageRead(
      messageId: msgIdInt,
      conversationId: convIdInt,
      senderId: currentIdInt,
    );
  }

  @override
  Future<void> setTypingStatus({
    required ConversationId conversationId,
    required bool isTyping,
  }) async {
    final currentUser = await _requireCurrentUser();
    final currentIdInt = int.parse(currentUser.id.value);
    final convIdInt = int.tryParse(conversationId.value);
    if (convIdInt == null) return;

    await client.chat.sendTypingEvent(
      conversationId: convIdInt,
      senderId: currentIdInt,
      isTyping: isTyping,
    );
  }

  Message? _findMessageById(MessageId messageId) {
    for (final msgs in _cachedMessages.values) {
      for (final m in msgs) {
        if (m.id == messageId) return m;
      }
    }
    return null;
  }

  Future<User> _requireCurrentUser() async {
    final cached = await storage.getUser();
    if (cached == null) {
      throw const UnauthorizedDomainActionException('User is not authenticated');
    }
    return User(
      id: UserId(cached.id),
      phoneNumber: PhoneNumber.parse(cached.phoneNumber),
      displayName: cached.displayName,
      bio: cached.bio,
      photoUrl: cached.photoUrl,
      notificationsEnabled: cached.notificationsEnabled,
      lastSeenAt: cached.lastSeenAt != null
          ? DateTime.tryParse(cached.lastSeenAt!)
          : null,
      createdAt: DateTime.parse(cached.createdAt),
    );
  }

  void dispose() {
    _conversationsController.close();
    for (final c in _messageControllers.values) {
      c.close();
    }
    for (final s in _subscriptions.values) {
      s.cancel();
    }
  }
}
