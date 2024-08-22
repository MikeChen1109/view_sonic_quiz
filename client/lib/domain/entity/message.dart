// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

enum EventType {
  message,
  connected;

  static EventType from(String value) {
    switch (value) {
      case 'message':
        return EventType.message;
      case 'connected':
        return EventType.connected;
      default:
        throw Exception('Invalid event type');
    }
  }
}

class Message {
  final EventType event;
  final Payload payload;

  Message({required this.event, required this.payload});

  factory Message.fromMap(Map<String, dynamic> map) {
    final eventStr = map['event'] as String;
    final event = EventType.from(eventStr);
    return Message(
      event: event,
      payload: Payload.fromMap(map['payload'] as Map<String, dynamic>, event),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': event.name,
      'payload': payload.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Payload {
  final String? message;
  final String? name;
  final String? senderId;
  final String? date;
  final int? currentUsers;
  final String? sessionId;

  Payload({
    this.message,
    this.name,
    this.senderId,
    this.date,
    this.currentUsers,
    this.sessionId,
  });

  factory Payload.fromMap(Map<String, dynamic> map, EventType event) {
    if (event == EventType.connected) {
      return Payload(
        sessionId: map['session_id'] as String,
      );
    }
    return Payload(
      message: map['message'] != null ? map['message'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      senderId: map['sender_id'] as String,
      date: map['date'] != null ? map['date'] as String : null,
      currentUsers:
          map['currentUsers'] != null ? map['currentUsers'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (message != null) {
      map['message'] = message;
    }
    if (name != null) {
      map['name'] = name;
    }
    if (senderId != null) {
      map['sender_id'] = senderId;
    }
    if (date != null) {
      map['date'] = date;
    }
    if (currentUsers != null) {
      map['currentUsers'] = currentUsers;
    }
    if (sessionId != null) {
      map['session_id'] = sessionId;
    }
    return map;
  }
}
