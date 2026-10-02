/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'chat/conversation.dart' as _isvwrlyz;
import 'chat/message.dart' as _iz1t3vul;
import 'localization/app_translation.dart' as _ipgqyns3;
import 'localization/translation_bundle.dart' as _ih31lup6;
import 'users/app_user.dart' as _iczy18ft;
export 'chat/conversation.dart';
export 'chat/message.dart';
export 'localization/app_translation.dart';
export 'localization/translation_bundle.dart';
export 'users/app_user.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _isvwrlyz.ConversationModel) {
      return _isvwrlyz.ConversationModel.fromJson(data) as T;
    }
    if (t == _iz1t3vul.MessageModel) {
      return _iz1t3vul.MessageModel.fromJson(data) as T;
    }
    if (t == _ipgqyns3.AppTranslation) {
      return _ipgqyns3.AppTranslation.fromJson(data) as T;
    }
    if (t == _ih31lup6.TranslationBundle) {
      return _ih31lup6.TranslationBundle.fromJson(data) as T;
    }
    if (t == _iczy18ft.AppUser) {
      return _iczy18ft.AppUser.fromJson(data) as T;
    }
    if (t == _isc.getType<_isvwrlyz.ConversationModel?>()) {
      return (data != null ? _isvwrlyz.ConversationModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iz1t3vul.MessageModel?>()) {
      return (data != null ? _iz1t3vul.MessageModel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipgqyns3.AppTranslation?>()) {
      return (data != null ? _ipgqyns3.AppTranslation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ih31lup6.TranslationBundle?>()) {
      return (data != null ? _ih31lup6.TranslationBundle.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iczy18ft.AppUser?>()) {
      return (data != null ? _iczy18ft.AppUser.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _isvwrlyz.ConversationModel => 'ConversationModel',
      _iz1t3vul.MessageModel => 'MessageModel',
      _ipgqyns3.AppTranslation => 'AppTranslation',
      _ih31lup6.TranslationBundle => 'TranslationBundle',
      _iczy18ft.AppUser => 'AppUser',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('chat.', '');
    }

    switch (data) {
      case _isvwrlyz.ConversationModel():
        return 'ConversationModel';
      case _iz1t3vul.MessageModel():
        return 'MessageModel';
      case _ipgqyns3.AppTranslation():
        return 'AppTranslation';
      case _ih31lup6.TranslationBundle():
        return 'TranslationBundle';
      case _iczy18ft.AppUser():
        return 'AppUser';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ConversationModel') {
      return deserialize<_isvwrlyz.ConversationModel>(data['data']);
    }
    if (dataClassName == 'MessageModel') {
      return deserialize<_iz1t3vul.MessageModel>(data['data']);
    }
    if (dataClassName == 'AppTranslation') {
      return deserialize<_ipgqyns3.AppTranslation>(data['data']);
    }
    if (dataClassName == 'TranslationBundle') {
      return deserialize<_ih31lup6.TranslationBundle>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_iczy18ft.AppUser>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('chat', this);
    _iacc.Protocol().registerHostProtocol('chat', this);
  }

  @override
  String getModuleName() => 'chat';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
