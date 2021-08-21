part of 'typing_bloc.dart';

abstract class TypingNotificationsEvent extends Equatable {
  const TypingNotificationsEvent();

  @override
  List<Object> get props => [];
}

class Subscribed extends TypingNotificationsEvent {
  final User user;
  late final List<String> userWithChat;

  Subscribed(this.user, this.userWithChat);

  @override
  List<Object> get props => [user, userWithChat];
}

class NotSubscribed extends TypingNotificationsEvent {}

class TypingSent extends TypingNotificationsEvent {
  final TypingEvent event;

  TypingSent(this.event);

  @override
  List<Object> get props => [event];
}

class TypingReceived extends TypingNotificationsEvent {
  final TypingEvent event;

  TypingReceived(this.event);

  @override
  List<Object> get props => [event];
}
