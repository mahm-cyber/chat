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

abstract class AppTranslation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppTranslation._({
    this.id,
    required this.locale,
    required this.key,
    required this.value,
    required this.version,
    required this.updatedAt,
  });

  factory AppTranslation({
    int? id,
    required String locale,
    required String key,
    required String value,
    required int version,
    required DateTime updatedAt,
  }) = _AppTranslationImpl;

  factory AppTranslation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppTranslation(
      id: jsonSerialization['id'] as int?,
      locale: jsonSerialization['locale'] as String,
      key: jsonSerialization['key'] as String,
      value: jsonSerialization['value'] as String,
      version: jsonSerialization['version'] as int,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String locale;

  String key;

  String value;

  int version;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AppTranslation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppTranslation copyWith({
    int? id,
    String? locale,
    String? key,
    String? value,
    int? version,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppTranslation',
      if (id != null) 'id': id,
      'locale': locale,
      'key': key,
      'value': value,
      'version': version,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppTranslation',
      if (id != null) 'id': id,
      'locale': locale,
      'key': key,
      'value': value,
      'version': version,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppTranslationImpl extends AppTranslation {
  _AppTranslationImpl({
    int? id,
    required String locale,
    required String key,
    required String value,
    required int version,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         locale: locale,
         key: key,
         value: value,
         version: version,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppTranslation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppTranslation copyWith({
    Object? id = _Undefined,
    String? locale,
    String? key,
    String? value,
    int? version,
    DateTime? updatedAt,
  }) {
    return AppTranslation(
      id: id is int? ? id : this.id,
      locale: locale ?? this.locale,
      key: key ?? this.key,
      value: value ?? this.value,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
