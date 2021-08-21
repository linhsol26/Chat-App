// @dart = 2.9
import 'package:chat/models/typing_event.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/typing/typing_notifications_service_contract.dart';
import 'package:chat_app/bloc/typing/typing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeTypingService extends Mock implements ITypingNofiticationsService {}

void main() {
  TypingBloc bloc;
  ITypingNofiticationsService typingNofiticationsService;
  User user;

  setUp(() {
    typingNofiticationsService = FakeTypingService();
    user = User(
        userName: 'test', photoUrl: '', active: true, lastSeen: DateTime.now());
    bloc = TypingBloc(typingNofiticationsService);
  });

  tearDown(() => typingNofiticationsService.dispose());

  test('should emit init without subscription', () {
    expect(bloc.state, TypingInitial());
  });

  test('should emit message sent state when message is sent', () {
    final event = TypingEvent(from: '123', to: '456', event: Typing.start);
    when(typingNofiticationsService.send(event: event))
        .thenAnswer((_) async => true);
    bloc.add(TypingSent(event));
    expect(bloc.stream, emits(TypingSentSuccess()));
  });

  test('should emit message received state when message is sent', () {
    final event = TypingEvent(from: '123', to: '456', event: Typing.start);

    when(typingNofiticationsService.subcribe(user, [event.from]))
        .thenAnswer((_) => Stream.fromIterable([event]));
    bloc.add(Subscribed(user, [event.from]));
    expect(bloc.stream, emitsInOrder([TypingReceivedSuccess(event)]));
  });

  test('should emit message notsubscribe state when message is sent', () {
    final event = TypingEvent(from: '123', to: '456', event: Typing.start);

    when(typingNofiticationsService.subcribe(user, []))
        .thenAnswer((_) => Stream.fromIterable([event]));
    bloc.add(NotSubscribed());
    expect(bloc.stream, emitsInOrder([]));
  });
}
