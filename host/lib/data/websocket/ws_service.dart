// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketService {
  Future<void> connect(String url);
  Future<void> disconnect();
  Stream<String> onMessage();
  Future<void> sendMessage(String message);
}

class WebSocketServiceImpl implements WebSocketService {
  WebSocketChannel? _channel;

  @override
  Future<void> connect(String url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    return await _channel?.ready;
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
  }

  @override
  Stream<String> onMessage() {
    return _channel?.stream.cast<String>() ?? const Stream.empty();
  }

  @override
  Future<void> sendMessage(String message) async {
    _channel?.sink.add(message);
  }
}
