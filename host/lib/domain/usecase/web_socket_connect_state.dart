import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_socket_connect_state.freezed.dart';

@freezed
class WebSocketConnectState with _$WebSocketConnectState {
  factory WebSocketConnectState.success() = success;
  factory WebSocketConnectState.error({required Object errorObject, required StackTrace stackTrace}) = error;
}
