import 'package:client/data/repository/web_socket_repo_impl.dart';
import 'package:client/data/websocket/ws_service.dart';
import 'package:client/domain/repository/web_socket_repository.dart';
import 'package:client/domain/usecase/send_message_usecase.dart';
import 'package:client/domain/usecase/web_socket_connect_usecase.dart';
import 'package:client/domain/usecase/web_socket_disconnect_usecase.dart';
import 'package:client/presentation/notifiers/client_state.dart';
import 'package:client/presentation/notifiers/client_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// service provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketServiceImpl();
});

// repository provider
final webSocketRepositoryProvider = Provider<WebSocketRepository>((ref) {
  return WebSocketRepoImpl(
    webSocketService: ref.read(webSocketServiceProvider),
  );
});

// usecase provider
final sendMessageUsecaseProvider =
    Provider.autoDispose<SendMessageUsecase>((ref) {
  return SendMessageUsecase(
    webSocketRepository: ref.read(webSocketRepositoryProvider),
  );
});

final webSocketConnectUsecaseProvider =
    Provider.autoDispose<WebSocketConnectUsecase>((ref) {
  return WebSocketConnectUsecase(
    webSocketRepository: ref.read(webSocketRepositoryProvider),
  );
});

final webSocketDisconnectUsecaseProvider =
    Provider.autoDispose<WebSocketDisconnectUsecase>((ref) {
  return WebSocketDisconnectUsecase(
    webSocketRepository: ref.read(webSocketRepositoryProvider),
  );
});

// notifier provider
final clientStateProvider =
    StateNotifierProvider<ClientStateNotifier, ClientState>((ref) {
  final WebSocketConnectUsecase webSocketConnectUsecase =
      ref.read(webSocketConnectUsecaseProvider);
  final WebSocketDisconnectUsecase webSocketDisconnectUsecase =
      ref.read(webSocketDisconnectUsecaseProvider);
  final SendMessageUsecase sendMessageUsecase =
      ref.read(sendMessageUsecaseProvider);
  return ClientStateNotifierImpl(
    ref,
    webSocketConnectUsecase,
    webSocketDisconnectUsecase,
    sendMessageUsecase,
  );
});

final userNameStateProvider = StateProvider<String>((ref) {
  return '';
});
