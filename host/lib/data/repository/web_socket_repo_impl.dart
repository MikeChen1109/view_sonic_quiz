import 'dart:async';
import 'package:host/data/websocket/ws_service.dart';
import 'package:host/domain/repository/web_socket_repository.dart';

class WebSocketRepoImpl implements WebSocketRepository {
  final WebSocketService _webSocketService;

  WebSocketRepoImpl({required WebSocketService webSocketService})
      : _webSocketService = webSocketService;

  @override
  Future<void> connect() async {
    return await _webSocketService.connect('ws://localhost:8000/ws');
  }

  @override
  Future<void> disconnect() async {
    return await _webSocketService.disconnect();
  }

  @override
  Stream<String> onMessage() {
    return _webSocketService.onMessage();
  }

  @override
  Future<void> sendMessage(String message) {
    return _webSocketService.sendMessage(message);
  }
}
