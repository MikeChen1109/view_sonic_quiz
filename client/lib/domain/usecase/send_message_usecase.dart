import 'package:client/domain/entity/message.dart';
import 'package:client/domain/repository/web_socket_repository.dart';
import 'package:client/domain/usecase/web_socket_connect_state.dart';

class SendMessageUsecase {
  final WebSocketRepository _webSocketRepository;

  SendMessageUsecase({required WebSocketRepository webSocketRepository})
      : _webSocketRepository = webSocketRepository;

  Future<WebSocketConnectState> execute({
    required String message,
    required String userName,
  }) async {
    try {
      final json = Message(
        event: EventType.message,
        payload: Payload(
          message: message,
          name: userName,
        ),
      ).toJson();
      await _webSocketRepository.sendMessage(json);
      return WebSocketConnectState.success();
    } catch (e, s) {
      return WebSocketConnectState.error(errorObject: e, stackTrace: s);
    }
  }
}
