import 'package:host/domain/repository/web_socket_repository.dart';

class SendMessageUsecase {
  final WebSocketRepository _webSocketRepository;

  SendMessageUsecase({required WebSocketRepository webSocketRepository})
      : _webSocketRepository = webSocketRepository;

  Future<void> execute({required String message}) async {
    return _webSocketRepository.sendMessage(message);
  }
}
