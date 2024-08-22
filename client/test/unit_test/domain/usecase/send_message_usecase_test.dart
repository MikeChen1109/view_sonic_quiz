import 'package:client/domain/repository/web_socket_repository.dart';
import 'package:client/domain/usecase/send_message_usecase.dart';
import 'package:client/domain/usecase/web_socket_connect_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_message_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebSocketRepository>(),
])
void main() {
  late WebSocketRepository webSocketRepository;

  setUp(() {
    webSocketRepository = MockWebSocketRepository();
  });

  test('send message success', () async {
    const fakeMessage = 'message';
    const fakeUserName = 'userName';
    const fakeJson = '{"event":"message","payload":{"message":"message","name":"userName"}}';
    when(webSocketRepository.sendMessage(fakeJson)).thenAnswer((_) async {});
    // given
    final usecase =
        SendMessageUsecase(webSocketRepository: webSocketRepository);
    // when
    final result = await usecase.execute(
      message: fakeMessage,
      userName: fakeUserName,
    );
    // then
    expect(result, WebSocketConnectState.success());
    verify(webSocketRepository.sendMessage(fakeJson)).called(1);
  });

  test('send message failure', () async {
    const fakeMessage = 'message';
    const fakeUserName = 'userName';
    const fakeJson = '{"event":"message","payload":{"message":"message","name":"userName"}}';
    final fakeStackTrace = StackTrace.fromString('stack trace');
    final fakeException = Exception();
    when(webSocketRepository.sendMessage(fakeJson)).thenAnswer(
        (_) async => throw await Future.error(fakeException, fakeStackTrace));
    // given
    final usecase =
        SendMessageUsecase(webSocketRepository: webSocketRepository);
    // when
    final result = await usecase.execute(
      message: fakeMessage,
      userName: fakeUserName,
    );
    // then
    expect(
      result,
      WebSocketConnectState.error(
        errorObject: fakeException,
        stackTrace: fakeStackTrace,
      ),
    );
    verify(webSocketRepository.sendMessage(fakeJson)).called(1);
  });
}
