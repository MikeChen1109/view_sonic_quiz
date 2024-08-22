import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_state.freezed.dart';

@freezed
class ClientState with _$ClientState {
  factory ClientState.connected() = connected;
  factory ClientState.idle() = loading;
}
