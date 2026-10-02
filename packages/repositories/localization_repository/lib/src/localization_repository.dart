import 'dart:async';
import 'package:chat_client/chat_client.dart';
import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

class LocalizationRepository implements ILocalizationRepository {
  final Client client;
  final KeyValueStorage storage;

  final StreamController<Map<String, String>> _controller =
      StreamController<Map<String, String>>.broadcast();

  Map<String, String> _currentTranslations = {};
  String _currentLocale = 'en';

  String get currentLocale => _currentLocale;

  LocalizationRepository({
    required this.client,
    required this.storage,
  });

  Future<void> initialize({String initialLocale = 'en'}) async {
    _currentLocale = initialLocale;

    // 1. Immediate synchronous read from local cache
    final cached = await storage.getTranslations(initialLocale);
    if (cached != null && cached.isNotEmpty) {
      _currentTranslations = cached;
      _controller.add(_currentTranslations);
    }

    // 2. Trigger asynchronous background sync with Serverpod
    unawaited(syncTranslations(initialLocale));
  }

  @override
  Stream<Map<String, String>> watchTranslations() {
    return _controller.stream;
  }

  @override
  String translate(String key, {Map<String, String>? parameters}) {
    var text = _currentTranslations[key] ?? key;
    if (parameters != null && parameters.isNotEmpty) {
      parameters.forEach((paramKey, paramValue) {
        text = text.replaceAll('{$paramKey}', paramValue);
      });
    }
    return text;
  }

  @override
  Future<void> syncTranslations(String locale) async {
    _currentLocale = locale;
    final cachedVersion = await storage.getTranslationVersion(locale);

    try {
      final bundle = await client.localization.getTranslations(
        locale: locale,
        clientVersion: cachedVersion,
      );

      if (bundle.translations.isNotEmpty) {
        _currentTranslations = bundle.translations;
        await storage.saveTranslations(
          locale,
          bundle.translations,
          bundle.version,
        );
        _controller.add(_currentTranslations);
      }
    } catch (_) {
      // Offline fallback: keep cached translations
    }
  }

  void dispose() {
    _controller.close();
  }
}
