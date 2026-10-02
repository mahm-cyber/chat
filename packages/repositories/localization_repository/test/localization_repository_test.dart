import 'package:chat_client/chat_client.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:localization_repository/localization_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

class MockEndpointLocalization extends Mock implements EndpointLocalization {}

void main() {
  group('LocalizationRepository', () {
    late MockClient client;
    late MockEndpointLocalization mockLocalization;
    late KeyValueStorage storage;
    late LocalizationRepository repo;

    setUp(() {
      client = MockClient();
      mockLocalization = MockEndpointLocalization();
      storage = KeyValueStorage();
      when(() => client.localization).thenReturn(mockLocalization);
      repo = LocalizationRepository(client: client, storage: storage);
    });

    tearDown(() {
      repo.dispose();
    });

    test('translate returns key if not found, and formats params', () {
      expect(repo.translate('unknown_key'), equals('unknown_key'));
    });

    test('initialize loads cached translations', () async {
      await storage.saveTranslations('en', {'app_title': 'Chat'}, 1);

      when(() => mockLocalization.getTranslations(
            locale: any(named: 'locale'),
            clientVersion: any(named: 'clientVersion'),
          )).thenAnswer((_) async => TranslationBundle(
            locale: 'en',
            version: 1,
            translations: {'app_title': 'Chat'},
          ));

      await repo.initialize(initialLocale: 'en');

      expect(repo.translate('app_title'), equals('Chat'));
    });

    test('syncTranslations fetches from client and saves to storage', () async {
      when(() => mockLocalization.getTranslations(
            locale: 'en',
            clientVersion: null,
          )).thenAnswer((_) async => TranslationBundle(
            locale: 'en',
            version: 2,
            translations: {'welcome': 'Hello {name}!'},
          ));

      await repo.syncTranslations('en');

      expect(repo.translate('welcome', parameters: {'name': 'Alice'}),
          equals('Hello Alice!'));

      final cached = await storage.getTranslations('en');
      expect(cached?['welcome'], equals('Hello {name}!'));
    });
  });
}
