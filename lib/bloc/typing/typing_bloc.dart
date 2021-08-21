import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/typing_event.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/typing/typing_notifications_service_contract.dart';
import 'package:equatable/equatable.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingBloc
    extends Bloc<TypingNotificationsEvent, TypingNotificationsState> {
  final ITypingNofiticationsService _typingNofiticationsService;
  StreamSubscription? _streamSubscription;
  TypingBloc(this._typingNofiticationsService) : super(TypingInitial());

  @override
  Stream<TypingNotificationsState> mapEventToState(
      TypingNotificationsEvent event) async* {
    if (event is Subscribed) {
      if (event.userWithChat == []) {
        add(NotSubscribed());
        return;
      }
      await _streamSubscription?.cancel();
      _streamSubscription = _typingNofiticationsService
          .subcribe(event.user, event.userWithChat)
          .listen((typingEvent) => add(TypingReceived(typingEvent)));
    }

    if (event is TypingReceived) {
      yield TypingReceivedSuccess(event.event);
    }
    if (event is TypingSent) {
      await _typingNofiticationsService.send(event: event.event);
      yield TypingSentSuccess();
    }

    if (event is NotSubscribed) {
      yield TypingInitial();
    }
  }
}
