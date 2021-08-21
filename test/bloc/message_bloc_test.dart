// @dart = 2.9
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/message/message_service_contract.dart';
import 'package:chat_app/bloc/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeMessageService extends Mock implements IMessageService {}

void main() {
  MessageBloc bloc;
  IMessageService messageService;
  User user;

  setUp(() {
    messageService = FakeMessageService();
    user = User(
        userName: 'test', photoUrl: '', active: true, lastSeen: DateTime.now());
    bloc = MessageBloc(messageService);
  });

  tearDown(() => messageService.dispose());

  test('should emit init without subscription', () {
    expect(bloc.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () {
    final message = Message(
        from: '123',
        to: '456',
        timestamp: DateTime.now(),
        contents: 'test contents');
    when(messageService.send(message)).thenAnswer((_) async => true);
    bloc.add(MessageSent(message));
    expect(bloc.stream, emits(MessageSentSuccess(message)));
  });

  test('should emit message received state when message is sent', () {
    final message = Message(
        from: '123',
        to: '456',
        timestamp: DateTime.now(),
        contents: 'test contents');
    when(messageService.messages(activeUser: anyNamed('activeUser')))
        .thenAnswer((_) => Stream.fromIterable([message]));
    bloc.add(Subscribed(user));
    expect(bloc.stream, emitsInOrder([MessageReceivedSuccess(message)]));
  });
}
