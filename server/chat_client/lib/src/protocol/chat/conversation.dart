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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ConversationModel
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ConversationModel._({
    this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageText,
    this.lastMessageSentAt,
    required this.unreadCountUser1,
    required this.unreadCountUser2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel({
    int? id,
    required int user1Id,
    required int user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    required int unreadCountUser1,
    required int unreadCountUser2,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ConversationModelImpl;

  factory ConversationModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConversationModel(
      id: jsonSerialization['id'] as int?,
      user1Id: jsonSerialization['user1Id'] as int,
      user2Id: jsonSerialization['user2Id'] as int,
      lastMessageText: jsonSerialization['lastMessageText'] as String?,
      lastMessageSentAt: jsonSerialization['lastMessageSentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageSentAt'],
            ),
      unreadCountUser1: jsonSerialization['unreadCountUser1'] as int,
      unreadCountUser2: jsonSerialization['unreadCountUser2'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int user1Id;

  int user2Id;

  String? lastMessageText;

  DateTime? lastMessageSentAt;

  int unreadCountUser1;

  int unreadCountUser2;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ConversationModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ConversationModel copyWith({
    int? id,
    int? user1Id,
    int? user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    int? unreadCountUser1,
    int? unreadCountUser2,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConversationModel',
      if (id != null) 'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      if (lastMessageText != null) 'lastMessageText': lastMessageText,
      if (lastMessageSentAt != null)
        'lastMessageSentAt': lastMessageSentAt?.toJson(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConversationModel',
      if (id != null) 'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      if (lastMessageText != null) 'lastMessageText': lastMessageText,
      if (lastMessageSentAt != null)
        'lastMessageSentAt': lastMessageSentAt?.toJson(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationModelImpl extends ConversationModel {
  _ConversationModelImpl({
    int? id,
    required int user1Id,
    required int user2Id,
    String? lastMessageText,
    DateTime? lastMessageSentAt,
    required int unreadCountUser1,
    required int unreadCountUser2,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         user1Id: user1Id,
         user2Id: user2Id,
         lastMessageText: lastMessageText,
         lastMessageSentAt: lastMessageSentAt,
         unreadCountUser1: unreadCountUser1,
         unreadCountUser2: unreadCountUser2,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ConversationModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ConversationModel copyWith({
    Object? id = _Undefined,
    int? user1Id,
    int? user2Id,
    Object? lastMessageText = _Undefined,
    Object? lastMessageSentAt = _Undefined,
    int? unreadCountUser1,
    int? unreadCountUser2,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationModel(
      id: id is int? ? id : this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      lastMessageText: lastMessageText is String?
          ? lastMessageText
          : this.lastMessageText,
      lastMessageSentAt: lastMessageSentAt is DateTime?
          ? lastMessageSentAt
          : this.lastMessageSentAt,
      unreadCountUser1: unreadCountUser1 ?? this.unreadCountUser1,
      unreadCountUser2: unreadCountUser2 ?? this.unreadCountUser2,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
