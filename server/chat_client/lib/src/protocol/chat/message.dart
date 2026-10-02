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

abstract class MessageModel
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MessageModel._({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.attachmentUrls,
    required this.status,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
  });

  factory MessageModel({
    int? id,
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
    required String status,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) = _MessageModelImpl;

  factory MessageModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageModel(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      senderId: jsonSerialization['senderId'] as int,
      recipientId: jsonSerialization['recipientId'] as int,
      content: jsonSerialization['content'] as String,
      attachmentUrls: jsonSerialization['attachmentUrls'] == null
          ? null
          : _ijors43j.Protocol().deserialize<List<String>>(
              jsonSerialization['attachmentUrls'],
            ),
      status: jsonSerialization['status'] as String,
      sentAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int conversationId;

  int senderId;

  int recipientId;

  String content;

  List<String>? attachmentUrls;

  String status;

  DateTime sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  /// Returns a shallow copy of this [MessageModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MessageModel copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    int? recipientId,
    String? content,
    List<String>? attachmentUrls,
    String? status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MessageModel',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      if (attachmentUrls != null) 'attachmentUrls': attachmentUrls?.toJson(),
      'status': status,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MessageModel',
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      if (attachmentUrls != null) 'attachmentUrls': attachmentUrls?.toJson(),
      'status': status,
      'sentAt': sentAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageModelImpl extends MessageModel {
  _MessageModelImpl({
    int? id,
    required int conversationId,
    required int senderId,
    required int recipientId,
    required String content,
    List<String>? attachmentUrls,
    required String status,
    required DateTime sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         senderId: senderId,
         recipientId: recipientId,
         content: content,
         attachmentUrls: attachmentUrls,
         status: status,
         sentAt: sentAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
       );

  /// Returns a shallow copy of this [MessageModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MessageModel copyWith({
    Object? id = _Undefined,
    int? conversationId,
    int? senderId,
    int? recipientId,
    String? content,
    Object? attachmentUrls = _Undefined,
    String? status,
    DateTime? sentAt,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
  }) {
    return MessageModel(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      attachmentUrls: attachmentUrls is List<String>?
          ? attachmentUrls
          : this.attachmentUrls?.map((e0) => e0).toList(),
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
    );
  }
}
