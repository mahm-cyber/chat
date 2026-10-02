abstract class ILocalizationRepository {
  Stream<Map<String, String>> watchTranslations();
  String translate(String key, {Map<String, String>? parameters});
  Future<void> syncTranslations(String locale);
}
