part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccess extends MessageState {
  final Message message;

  MessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccess extends MessageState {
  final Message message;

  MessageReceivedSuccess(this.message);

  @override
  List<Object> get props => [message];
}
