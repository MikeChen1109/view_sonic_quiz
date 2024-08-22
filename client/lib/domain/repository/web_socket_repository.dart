abstract class WebSocketRepository {
  Future<void> connect();
  Future<void> disconnect();
  Stream<String> onMessage();
  Future<void> sendMessage(String message);
}
