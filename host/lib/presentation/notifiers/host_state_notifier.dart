import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host/domain/usecase/web_socket_connect_usecase.dart';

abstract class HostStateNotifier extends StateNotifier<AsyncValue<bool>> {
  HostStateNotifier() : super(const AsyncValue.loading());
}

class HostStateNotifierImpl extends HostStateNotifier {
  final WebSocketConnectUsecase webSocketConnectUsecase;
  Ref ref;

  HostStateNotifierImpl(this.ref, this.webSocketConnectUsecase) : super() {
    _init();
  }

  Future<void> _init() async {
    final result = await webSocketConnectUsecase.execute();
    result.when(
      success: () {
        state = const AsyncValue.data(true);
      },
      error: (errorObject, stackTrace) {
        state = AsyncValue.error(errorObject, stackTrace);
      },
    );
  }
}
