import 'package:client/domain/entity/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Event type to String', () {
    // given
    const event = EventType.message;
    // when
    final eventStr = event.name;
    // then
    expect(eventStr, 'message');
  });
}
