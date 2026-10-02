import 'package:domain_models/domain_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockChatRepository extends Mock implements IChatRepository {}

void main() {
  late MockChatRepository mockChatRepo;
  late SendMessageUseCase useCase;

  setUpAll(() {
    registerFallbackValue(ConversationId('dummy'));
    registerFallbackValue(UserId('dummy'));
    registerFallbackValue(MessageContent.create(text: 'dummy'));
  });

  setUp(() {
    mockChatRepo = MockChatRepository();
    useCase = SendMessageUseCase(mockChatRepo);
  });

  test('validates text before delegating to repository', () async {
    final convId = ConversationId('conv_1');
    final recipientId = UserId('user_2');

    expect(
      () => useCase.execute(
        conversationId: convId,
        recipientId: recipientId,
        text: '   ',
      ),
      throwsA(isA<InvalidMessageContentException>()),
    );

    verifyZeroInteractions(mockChatRepo);
  });

  test('delegates valid message to repository and returns message entity', () async {
    final convId = ConversationId('conv_1');
    final recipientId = UserId('user_2');
    final senderId = UserId('user_1');
    final expectedMessage = Message(
      id: MessageId('msg_100'),
      conversationId: convId,
      senderId: senderId,
      recipientId: recipientId,
      content: MessageContent.create(text: 'Hello!'),
      status: MessageStatus.sent,
      sentAt: DateTime.now().toUtc(),
    );

    when(
      () => mockChatRepo.sendMessage(
        conversationId: any(named: 'conversationId'),
        recipientId: any(named: 'recipientId'),
        content: any(named: 'content'),
      ),
    ).thenAnswer((_) async => expectedMessage);

    final result = await useCase.execute(
      conversationId: convId,
      recipientId: recipientId,
      text: 'Hello!',
    );

    expect(result, equals(expectedMessage));
    verify(
      () => mockChatRepo.sendMessage(
        conversationId: convId,
        recipientId: recipientId,
        content: MessageContent.create(text: 'Hello!'),
      ),
    ).called(1);
  });
}
