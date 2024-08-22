import 'package:client/di/dependency_injections.dart';
import 'package:client/domain/usecase/send_message_usecase.dart';
import 'package:client/domain/usecase/web_socket_connect_state.dart';
import 'package:client/domain/usecase/web_socket_connect_usecase.dart';
import 'package:client/domain/usecase/web_socket_disconnect_usecase.dart';
import 'package:client/main.dart';
import 'package:client/presentation/notifiers/client_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'client_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebSocketConnectUsecase>(),
  MockSpec<WebSocketDisconnectUsecase>(),
  MockSpec<SendMessageUsecase>(),
])
void main() {
  testWidgets('connect success', (tester) async {
    final webSocketConnectUsecase = MockWebSocketConnectUsecase();
    final webSocketDisconnectUsecase = MockWebSocketDisconnectUsecase();
    final sendMessageUsecase = MockSendMessageUsecase();
    when(webSocketConnectUsecase.execute())
        .thenAnswer((_) async => WebSocketConnectState.success());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientStateProvider.overrideWith(
            (ref) => ClientStateNotifierImpl(
              ref,
              webSocketConnectUsecase,
              webSocketDisconnectUsecase,
              sendMessageUsecase,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
    final nameTextField = find.byType(TextField);
    final connectButton = find.text('Connect');
    await tester.enterText(nameTextField, 'name');
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);
  });

  testWidgets('connect failed', (tester) async {
    final webSocketConnectUsecase = MockWebSocketConnectUsecase();
    final webSocketDisconnectUsecase = MockWebSocketDisconnectUsecase();
    final sendMessageUsecase = MockSendMessageUsecase();
    final fakeException = Exception('fake exception');
    final fakeStackTrace = StackTrace.current;
    when(webSocketConnectUsecase.execute()).thenAnswer(
      (_) async => WebSocketConnectState.error(
        errorObject: fakeException,
        stackTrace: fakeStackTrace,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientStateProvider.overrideWith(
            (ref) => ClientStateNotifierImpl(
              ref,
              webSocketConnectUsecase,
              webSocketDisconnectUsecase,
              sendMessageUsecase,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
    final nameTextField = find.byType(TextField);
    final connectButton = find.text('Connect');
    await tester.enterText(nameTextField, 'name');
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    expect(find.text('send'), findsNothing);
    expect(find.text('exit'), findsNothing);
  });
}
