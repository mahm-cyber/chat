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
import 'package:chat_server/src/generated/protocol.dart' as _i2wttstz;
import 'package:serverpod/serverpod.dart' as _is;

abstract class TranslationBundle
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TranslationBundle._({
    required this.locale,
    required this.version,
    required this.translations,
  });

  factory TranslationBundle({
    required String locale,
    required int version,
    required Map<String, String> translations,
  }) = _TranslationBundleImpl;

  factory TranslationBundle.fromJson(Map<String, dynamic> jsonSerialization) {
    return TranslationBundle(
      locale: jsonSerialization['locale'] as String,
      version: jsonSerialization['version'] as int,
      translations: _i2wttstz.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['translations'],
      ),
    );
  }

  String locale;

  int version;

  Map<String, String> translations;

  /// Returns a shallow copy of this [TranslationBundle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TranslationBundle copyWith({
    String? locale,
    int? version,
    Map<String, String>? translations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TranslationBundle',
      'locale': locale,
      'version': version,
      'translations': translations.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TranslationBundle',
      'locale': locale,
      'version': version,
      'translations': translations.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TranslationBundleImpl extends TranslationBundle {
  _TranslationBundleImpl({
    required String locale,
    required int version,
    required Map<String, String> translations,
  }) : super._(
         locale: locale,
         version: version,
         translations: translations,
       );

  /// Returns a shallow copy of this [TranslationBundle]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TranslationBundle copyWith({
    String? locale,
    int? version,
    Map<String, String>? translations,
  }) {
    return TranslationBundle(
      locale: locale ?? this.locale,
      version: version ?? this.version,
      translations:
          translations ??
          this.translations.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
