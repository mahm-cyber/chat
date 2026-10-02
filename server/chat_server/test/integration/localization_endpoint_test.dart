import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given LocalizationEndpoint', (sessionBuilder, endpoints) {
    test('when requesting en translations then returns english bundle', () async {
      final bundle = await endpoints.localization.getTranslations(
        sessionBuilder,
        locale: 'en',
      );

      expect(bundle.locale, equals('en'));
      expect(bundle.translations.containsKey('auth.welcome_title'), isTrue);
      expect(bundle.translations['auth.welcome_title'], equals('Welcome to Chat'));
      expect(bundle.translations.containsKey('chat.send_button'), isTrue);
    });

    test('when requesting ar translations then returns arabic bundle', () async {
      final bundle = await endpoints.localization.getTranslations(
        sessionBuilder,
        locale: 'ar',
      );

      expect(bundle.locale, equals('ar'));
      expect(bundle.translations.containsKey('auth.welcome_title'), isTrue);
      expect(bundle.translations['auth.welcome_title'], equals('مرحباً بك في المحادثات'));
    });
  });
}
