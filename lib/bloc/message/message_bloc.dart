import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/message/message_service_contract.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  StreamSubscription? _streamSubscription;

  MessageBloc(this._messageService) : super(MessageInitial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is Subscribed) {
      await _streamSubscription?.cancel();
      _streamSubscription =
          _messageService.messages(activeUser: event.user).listen((message) {
        add(MessageReceived(message));
      });
    } else if (event is MessageReceived) {
      yield MessageReceivedSuccess(event.message);
    } else if (event is MessageSent) {
      await _messageService.send(event.message);
      yield MessageSentSuccess(event.message);
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
