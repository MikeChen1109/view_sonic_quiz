import 'package:vania/vania.dart';

class ChatWebSocketController extends Controller {
  Future newMessage(WebSocketClient client, dynamic payload) async {
    try {
      final String message = payload['message'];
      final String name = payload['name'];
      final String date = DateTime.now().toString();
      final int count = client.activeSessions.length - 1;

      final Map<String, dynamic> messages = {
        'message': message,
        'sender_id': client.clientId,
        'date': date,
        'name': name,
        'currentUsers': count,
      };

      client.broadcast('message', messages);
    } catch (e) {
      client.emit('error', {
        'message': 'Invalid payload',
        'error': e.toString(),
      });
    }
  }
}

ChatWebSocketController chatController = ChatWebSocketController();
