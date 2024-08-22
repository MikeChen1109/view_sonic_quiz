import 'package:flutter_test/flutter_test.dart';
import 'package:host/domain/entity/message.dart';
import 'package:host/domain/repository/web_socket_repository.dart';
import 'package:host/domain/usecase/stream_message_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_message_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebSocketRepository>(),
])
void main() {
  late WebSocketRepository webSocketRepository;

  setUp(() {
    webSocketRepository = MockWebSocketRepository();
  });

  test('stream message success', () {
    const json =
        '{"event":"message", "payload": {"message":"hello", "name": "Mike", "date": "2022-01-01", "currentUsers": 10, "sender_id": "123"}}';
    when(webSocketRepository.onMessage())
        .thenAnswer((_) => Stream.fromIterable([json]));
    // given
    final usecase =
        StreamMessageUsecase(webSocketRepository: webSocketRepository);
    // when
    final stream = usecase.execute();
    // then
    stream.listen(expectAsync1((message) {
      expect(message.event, EventType.message);
      expect(message.payload.message, 'hello');
      expect(message.payload.name, 'Mike');
      expect(message.payload.date, '2022-01-01');
      expect(message.payload.currentUsers, 10);
      expect(message.payload.senderId, '123');
      verify(webSocketRepository.onMessage()).called(1);
    }, count: 1));
  });

  test('stream message failure', () {
    when(webSocketRepository.onMessage())
        .thenAnswer((_) => throw const FormatException());
    // given
    final usecase =
        StreamMessageUsecase(webSocketRepository: webSocketRepository);
    // when
    final stream = usecase.execute();
    // then
    stream.listen(
      expectAsync1((message) {
        fail('should not be called');
      }, count: 0),
      onError: expectAsync1((error) {
        expect(error, isA<FormatException>());
        verify(webSocketRepository.onMessage()).called(1);
      }, count: 1),
    );
  });
}
