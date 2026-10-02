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

abstract class AppUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.firebaseUid,
    required this.phoneNumber,
    required this.displayName,
    this.bio,
    this.photoUrl,
    required this.notificationsEnabled,
    this.lastSeenAt,
    required this.createdAt,
  });

  factory AppUser({
    int? id,
    required String firebaseUid,
    required String phoneNumber,
    required String displayName,
    String? bio,
    String? photoUrl,
    required bool notificationsEnabled,
    DateTime? lastSeenAt,
    required DateTime createdAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
      photoUrl: jsonSerialization['photoUrl'] as String?,
      notificationsEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['notificationsEnabled'],
      ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String firebaseUid;

  String phoneNumber;

  String displayName;

  String? bio;

  String? photoUrl;

  bool notificationsEnabled;

  DateTime? lastSeenAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUser copyWith({
    int? id,
    String? firebaseUid,
    String? phoneNumber,
    String? displayName,
    String? bio,
    String? photoUrl,
    bool? notificationsEnabled,
    DateTime? lastSeenAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'notificationsEnabled': notificationsEnabled,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'notificationsEnabled': notificationsEnabled,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String firebaseUid,
    required String phoneNumber,
    required String displayName,
    String? bio,
    String? photoUrl,
    required bool notificationsEnabled,
    DateTime? lastSeenAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         firebaseUid: firebaseUid,
         phoneNumber: phoneNumber,
         displayName: displayName,
         bio: bio,
         photoUrl: photoUrl,
         notificationsEnabled: notificationsEnabled,
         lastSeenAt: lastSeenAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? firebaseUid,
    String? phoneNumber,
    String? displayName,
    Object? bio = _Undefined,
    Object? photoUrl = _Undefined,
    bool? notificationsEnabled,
    Object? lastSeenAt = _Undefined,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
