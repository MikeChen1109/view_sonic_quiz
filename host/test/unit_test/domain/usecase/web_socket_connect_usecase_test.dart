import 'package:flutter_test/flutter_test.dart';
import 'package:host/domain/repository/web_socket_repository.dart';
import 'package:host/domain/usecase/web_socket_connect_state.dart';
import 'package:host/domain/usecase/web_socket_connect_usecase.dart';
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

  test('connect success', () async {
    when(webSocketRepository.connect()).thenAnswer((_) async {});
    // given
    final usecase =
        WebSocketConnectUsecase(webSocketRepository: webSocketRepository);
    // when
    final result = await usecase.execute();
    // then
    expect(result, WebSocketConnectState.success());
    verify(webSocketRepository.connect()).called(1);
  });

  test('connect failure', () async {
    final fakeStackTrace = StackTrace.fromString('stack trace');
    final fakeException = Exception();
    when(webSocketRepository.connect())
        .thenAnswer((_) async => throw await Future.error(fakeException, fakeStackTrace));
    // given
    final usecase =
        WebSocketConnectUsecase(webSocketRepository: webSocketRepository);
    // when
    final result = await usecase.execute();
    // then
    expect(
      result,
      WebSocketConnectState.error(
        errorObject: fakeException,
        stackTrace: fakeStackTrace,
      ),
    );
    verify(webSocketRepository.connect()).called(1);
  });
}
