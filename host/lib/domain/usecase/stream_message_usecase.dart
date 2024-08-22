import 'dart:async';
import 'dart:convert';

import 'package:host/domain/entity/message.dart';
import 'package:host/domain/repository/web_socket_repository.dart';

class StreamMessageUsecase {
  final WebSocketRepository _webSocketRepository;
  late final StreamController<Message> _streamController;

  StreamMessageUsecase({required WebSocketRepository webSocketRepository})
      : _webSocketRepository = webSocketRepository {
    _streamController = StreamController<Message>();
  }

  Stream<Message> execute() async* {
    _webSocketRepository.onMessage().listen((event) {
      try {
        final map = json.decode(event) as Map<String, dynamic>;
        final message = Message.fromMap(map);
        _streamController.add(message);
      } catch (e) {
        _streamController.addError(e);
      }
    }, onError: (error) {
      _streamController.addError(error);
    }, onDone: () {
      _streamController.close();
    });

    yield* _streamController.stream;
  }
}
