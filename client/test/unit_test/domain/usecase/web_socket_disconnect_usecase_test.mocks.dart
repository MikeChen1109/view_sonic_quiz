// Mocks generated by Mockito 5.4.4 from annotations
// in client/test/unit_test/domain/usecase/web_socket_disconnect_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:client/domain/repository/web_socket_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [WebSocketRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebSocketRepository extends _i1.Mock
    implements _i2.WebSocketRepository {
  @override
  _i3.Future<void> connect() => (super.noSuchMethod(
        Invocation.method(
          #connect,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> disconnect() => (super.noSuchMethod(
        Invocation.method(
          #disconnect,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Stream<String> onMessage() => (super.noSuchMethod(
        Invocation.method(
          #onMessage,
          [],
        ),
        returnValue: _i3.Stream<String>.empty(),
        returnValueForMissingStub: _i3.Stream<String>.empty(),
      ) as _i3.Stream<String>);

  @override
  _i3.Future<void> sendMessage(String? message) => (super.noSuchMethod(
        Invocation.method(
          #sendMessage,
          [message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
