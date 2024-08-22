import 'package:flutter_test/flutter_test.dart';
import 'package:host/domain/entity/message.dart';

void main() {
  test('When event is not message', () {
    // given
    const map = {
      'event': 'connected',
      'payload': {
        'session_id': 'abcdefg1234',
      },
    };
    // when
    final message = Message.fromMap(map);
    // then
    expect(message.event, EventType.connected);
    expect(message.payload.sessionId, 'abcdefg1234');
    expect(message.payload.message, null);
    expect(message.payload.name, null);
    expect(message.payload.senderId, null);
    expect(message.payload.date, null);
    expect(message.payload.currentUsers, null);
  });

  test('When event is message', () {
    // given
    const map = {
      'event': 'message',
      'payload': {
        'message': 'Hello',
        'name': 'Alice',
        'sender_id': '1234',
        'date': '2021-10-01T00:00:00',
        'currentUsers': 1,
      },
    };
    // when
    final message = Message.fromMap(map);
    // then
    expect(message.event, EventType.message);
    expect(message.payload.sessionId, null);
    expect(message.payload.message, 'Hello');
    expect(message.payload.name, 'Alice');
    expect(message.payload.senderId, '1234');
    expect(message.payload.date, '2021-10-01T00:00:00');
    expect(message.payload.currentUsers, 1);
  });
}
