/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chat_client/src/protocol/protocol.dart' as _ijors43j;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../chat/message.dart' as _iqm8bky3;

abstract class ChatEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChatEvent._({
    required this.type,
    required this.conversationId,
    required this.senderId,
    this.message,
    this.messageId,
    this.isTyping,
    required this.timestamp,
  });

  factory ChatEvent({
    required String type,
    required int conversationId,
    required int senderId,
    _iqm8bky3.MessageModel? message,
    int? messageId,
    bool? isTyping,
    required DateTime timestamp,
  }) = _ChatEventImpl;

  factory ChatEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatEvent(
      type: jsonSerialization['type'] as String,
      conversationId: jsonSerialization['conversationId'] as int,
      senderId: jsonSerialization['senderId'] as int,
      message: jsonSerialization['message'] == null
          ? null
          : _ijors43j.Protocol().deserialize<_iqm8bky3.MessageModel>(
              jsonSerialization['message'],
            ),
      messageId: jsonSerialization['messageId'] as int?,
      isTyping: jsonSerialization['isTyping'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isTyping']),
      timestamp: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  String type;

  int conversationId;

  int senderId;

  _iqm8bky3.MessageModel? message;

  int? messageId;

  bool? isTyping;

  DateTime timestamp;

  /// Returns a shallow copy of this [ChatEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChatEvent copyWith({
    String? type,
    int? conversationId,
    int? senderId,
    _iqm8bky3.MessageModel? message,
    int? messageId,
    bool? isTyping,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatEvent',
      'type': type,
      'conversationId': conversationId,
      'senderId': senderId,
      if (message != null) 'message': message?.toJson(),
      if (messageId != null) 'messageId': messageId,
      if (isTyping != null) 'isTyping': isTyping,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatEvent',
      'type': type,
      'conversationId': conversationId,
      'senderId': senderId,
      if (message != null) 'message': message?.toJsonForProtocol(),
      if (messageId != null) 'messageId': messageId,
      if (isTyping != null) 'isTyping': isTyping,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatEventImpl extends ChatEvent {
  _ChatEventImpl({
    required String type,
    required int conversationId,
    required int senderId,
    _iqm8bky3.MessageModel? message,
    int? messageId,
    bool? isTyping,
    required DateTime timestamp,
  }) : super._(
         type: type,
         conversationId: conversationId,
         senderId: senderId,
         message: message,
         messageId: messageId,
         isTyping: isTyping,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [ChatEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChatEvent copyWith({
    String? type,
    int? conversationId,
    int? senderId,
    Object? message = _Undefined,
    Object? messageId = _Undefined,
    Object? isTyping = _Undefined,
    DateTime? timestamp,
  }) {
    return ChatEvent(
      type: type ?? this.type,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      message: message is _iqm8bky3.MessageModel?
          ? message
          : this.message?.copyWith(),
      messageId: messageId is int? ? messageId : this.messageId,
      isTyping: isTyping is bool? ? isTyping : this.isTyping,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
