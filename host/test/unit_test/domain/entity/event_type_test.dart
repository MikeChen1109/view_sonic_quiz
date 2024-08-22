import 'package:flutter_test/flutter_test.dart';
import 'package:host/domain/entity/message.dart';

void main() {
  test('Event type from String', () {
    // given
    const eventStr = 'message';
    // when
    final event = EventType.from(eventStr);
    // then
    expect(event, EventType.message);
  });
}
