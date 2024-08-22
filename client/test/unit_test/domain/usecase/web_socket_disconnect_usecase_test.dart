import 'package:client/domain/repository/web_socket_repository.dart';
import 'package:client/domain/usecase/web_socket_connect_state.dart';
import 'package:client/domain/usecase/web_socket_disconnect_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'web_socket_disconnect_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebSocketRepository>(),
])
void main() {
  late WebSocketRepository webSocketRepository;

  setUp(() {
    webSocketRepository = MockWebSocketRepository();
  });

  test('disconnect success', () async {
    when(webSocketRepository.disconnect()).thenAnswer((_) async {});
    // given
    final usecase =
        WebSocketDisconnectUsecase(webSocketRepository: webSocketRepository);
    // when
    final result = await usecase.execute();
    // then
    expect(result, WebSocketConnectState.success());
    verify(webSocketRepository.disconnect()).called(1);
  });

  test('disconnect failure', () async {
    final fakeStackTrace = StackTrace.fromString('stack trace');
    final fakeException = Exception();
    when(webSocketRepository.disconnect())
        .thenAnswer((_) async => throw await Future.error(fakeException, fakeStackTrace));
    // given
    final usecase =
        WebSocketDisconnectUsecase(webSocketRepository: webSocketRepository);
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
    verify(webSocketRepository.disconnect()).called(1);
  });
}
