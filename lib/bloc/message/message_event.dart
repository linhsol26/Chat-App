part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class Subscribed extends MessageEvent {
  final User user;

  Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class MessageSent extends MessageEvent {
  final Message message;

  MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceived extends MessageEvent {
  final Message message;

  MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}
