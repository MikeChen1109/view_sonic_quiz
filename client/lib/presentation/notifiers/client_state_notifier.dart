import 'dart:async';
import 'package:client/di/dependency_injections.dart';
import 'package:client/domain/usecase/send_message_usecase.dart';
import 'package:client/domain/usecase/web_socket_connect_usecase.dart';
import 'package:client/domain/usecase/web_socket_disconnect_usecase.dart';
import 'package:client/presentation/notifiers/client_state.dart';
import 'package:client/presentation/utils/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ClientStateNotifier extends StateNotifier<ClientState> {
  ClientStateNotifier() : super(ClientState.idle());

  Future<void> connect(String userName);
  Future<void> disconnect();
  Future<void> sendMessage(String message);
}

class ClientStateNotifierImpl extends ClientStateNotifier {
  final WebSocketConnectUsecase webSocketConnectUsecase;
  final WebSocketDisconnectUsecase webSocketDisconnectUsecase;
  final SendMessageUsecase sendMessageUsecase;
  Ref ref;

  ClientStateNotifierImpl(
    this.ref,
    this.webSocketConnectUsecase,
    this.webSocketDisconnectUsecase,
    this.sendMessageUsecase,
  ) : super();

  @override
  Future<void> connect(String userName) async {
    final result = await webSocketConnectUsecase.execute();
    result.when(
      success: () {
        ref.read(userNameStateProvider.notifier).state = userName;
        state = ClientState.connected();
      },
      error: (errorObject, stackTrace) {
        ToastHelper.show("connect failed");
        state = ClientState.idle();
      },
    );
  }

  @override
  Future<void> disconnect() async {
    final result = await webSocketDisconnectUsecase.execute();
    result.when(
      success: () {
        state = ClientState.idle();
      },
      error: (errorObject, stackTrace) {
        ToastHelper.show("disconnect failed");
      },
    );
  }

  @override
  Future<void> sendMessage(String message) async {
    final name = ref.read(userNameStateProvider);
    final result = await sendMessageUsecase.execute(
      message: message,
      userName: name,
    );
    result.when(
      success: () {
        ToastHelper.show("send message success");
      },
      error: (errorObject, stackTrace) {
        ToastHelper.show("send message failed");
      },
    );
  }

}
