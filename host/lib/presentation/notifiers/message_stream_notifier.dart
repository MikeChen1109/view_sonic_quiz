import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host/di/dependency_injections.dart';
import 'package:host/domain/entity/message.dart';
import 'package:host/domain/usecase/send_message_usecase.dart';
import 'package:host/domain/usecase/stream_message_usecase.dart';

abstract class MessageStreamNotifier extends StreamNotifier<Message> {
  Future<void> sendMessage(String message);
}

class MessageStreamNotifierImpl extends MessageStreamNotifier {
  late final StreamMessageUsecase streamMessageUsecase;
  late final SendMessageUsecase sendMessageUsecase;

  MessageStreamNotifierImpl() : super();

  @override
  Stream<Message> build() {
    streamMessageUsecase = ref.read(streamMessageUsecaseProvider);
    sendMessageUsecase = ref.read(sendMessageUsecaseProvider);
    return streamMessageUsecase.execute();
  }

  @override
  Future<void> sendMessage(String message) async {
    return sendMessageUsecase.execute(message: message);
  }
}
