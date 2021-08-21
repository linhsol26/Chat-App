part of 'typing_bloc.dart';

abstract class TypingNotificationsState extends Equatable {
  const TypingNotificationsState();

  @override
  List<Object> get props => [];
}

class TypingInitial extends TypingNotificationsState {}

class TypingSentSuccess extends TypingNotificationsState {}

class TypingReceivedSuccess extends TypingNotificationsState {
  final TypingEvent typingEvent;

  TypingReceivedSuccess(this.typingEvent);

  @override
  List<Object> get props => [typingEvent];
}
