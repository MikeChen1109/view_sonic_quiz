import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:host/di/dependency_injections.dart';
import 'package:host/domain/entity/message.dart';
import 'package:host/domain/usecase/stream_message_usecase.dart';
import 'package:host/domain/usecase/web_socket_connect_state.dart';
import 'package:host/domain/usecase/web_socket_connect_usecase.dart';
import 'package:host/main.dart';
import 'package:host/presentation/notifiers/host_state_notifier.dart';
import 'package:host/presentation/widgets/message_list_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'host_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebSocketConnectUsecase>(),
  MockSpec<StreamMessageUsecase>(),
])
void main() {
  testWidgets('When connect success', (tester) async {
    final streamMessageUsecase = MockStreamMessageUsecase();
    final webSocketConnectUsecase = MockWebSocketConnectUsecase();
    when(webSocketConnectUsecase.execute())
        .thenAnswer((_) async => WebSocketConnectState.success());
    when(streamMessageUsecase.execute()).thenAnswer((_) async* {
      yield Message(event: EventType.connected, payload: Payload());
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hostStateProvider.overrideWith(
            (ref) => HostStateNotifierImpl(ref, webSocketConnectUsecase),
          ),
          streamMessageUsecaseProvider.overrideWith(
            (ref) => streamMessageUsecase,
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host'), findsOneWidget);
    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.text('connected'), findsOneWidget);
    expect(find.byType(MessageListView), findsOneWidget);
  });

  testWidgets('When connect failed', (tester) async {
    final fakeException = Exception('fake exception');
    final fakeStackTrace = StackTrace.current;
    final webSocketConnectUsecase = MockWebSocketConnectUsecase();
    when(webSocketConnectUsecase.execute()).thenAnswer(
      (_) async => WebSocketConnectState.error(
        errorObject: fakeException,
        stackTrace: fakeStackTrace,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hostStateProvider.overrideWith(
            (ref) => HostStateNotifierImpl(ref, webSocketConnectUsecase),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ErrorWidget), findsOneWidget);
  });
}
