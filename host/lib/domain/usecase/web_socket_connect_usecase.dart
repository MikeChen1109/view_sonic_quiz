import 'dart:async';
import 'package:host/domain/repository/web_socket_repository.dart';
import 'package:host/domain/usecase/web_socket_connect_state.dart';

class WebSocketConnectUsecase {
  final WebSocketRepository _webSocketRepository;

  WebSocketConnectUsecase({required WebSocketRepository webSocketRepository})
      : _webSocketRepository = webSocketRepository;

  Future<WebSocketConnectState> execute() async {
    try {
      await _webSocketRepository.connect();
      return WebSocketConnectState.success();
    } catch (e, s) {
      return WebSocketConnectState.error(errorObject: e, stackTrace: s);
    }
  }
}
