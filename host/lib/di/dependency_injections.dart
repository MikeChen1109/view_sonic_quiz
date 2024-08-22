import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host/data/repository/web_socket_repo_impl.dart';
import 'package:host/data/websocket/ws_service.dart';
import 'package:host/domain/entity/message.dart';
import 'package:host/domain/repository/web_socket_repository.dart';
import 'package:host/domain/usecase/send_message_usecase.dart';
import 'package:host/domain/usecase/stream_message_usecase.dart';
import 'package:host/domain/usecase/web_socket_connect_usecase.dart';
import 'package:host/presentation/notifiers/host_state_notifier.dart';
import 'package:host/presentation/notifiers/message_stream_notifier.dart';

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
final streamMessageUsecaseProvider =
    Provider.autoDispose<StreamMessageUsecase>((ref) {
  return StreamMessageUsecase(
    webSocketRepository: ref.read(webSocketRepositoryProvider),
  );
});

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

// notifier provider
final messageStreamProvider =
    StreamNotifierProvider<MessageStreamNotifier, Message>(
  () {
    return MessageStreamNotifierImpl();
  },
);

final hostStateProvider =
    StateNotifierProvider<HostStateNotifier, AsyncValue<bool>>((ref) {
  final WebSocketConnectUsecase webSocketConnectUsecase =
      ref.read(webSocketConnectUsecaseProvider);
  return HostStateNotifierImpl(ref, webSocketConnectUsecase);
});
