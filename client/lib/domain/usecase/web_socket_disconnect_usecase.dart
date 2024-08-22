import 'dart:async';
import 'package:client/domain/repository/web_socket_repository.dart';
import 'package:client/domain/usecase/web_socket_connect_state.dart';

class WebSocketDisconnectUsecase {
  final WebSocketRepository _webSocketRepository;

  WebSocketDisconnectUsecase({required WebSocketRepository webSocketRepository})
      : _webSocketRepository = webSocketRepository;

  Future<WebSocketConnectState> execute() async {
    try {
      await _webSocketRepository.disconnect();
      return WebSocketConnectState.success();
    } catch (e, s) {
      return WebSocketConnectState.error(errorObject: e, stackTrace: s);
    }
  }
}
