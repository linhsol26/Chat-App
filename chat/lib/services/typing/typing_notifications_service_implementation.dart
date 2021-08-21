import 'dart:async';

import 'package:chat/models/user.dart';
import 'package:chat/models/typing_event.dart';
import 'package:chat/services/typing/typing_notifications_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class TypingNotificationsService implements ITypingNofiticationsService {
  final Connection connection;
  final Rethinkdb rethinkdb;

  TypingNotificationsService(
      {required this.connection, required this.rethinkdb});

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _streamSubscriptionChangeFeed;

  @override
  Future<bool> send({required TypingEvent event, User? to}) async {
    if (!to!.active) return false;
    Map record = await rethinkdb
        .table('typing_events')
        .insert(event.toJson(), {'conflict': 'update'}).run(connection);
    return record['inserted'] == 1;
  }

  @override
  Stream<TypingEvent> subcribe(User user, List<String> usersId) {
    _startReceivingTypingEvents(user, usersId);
    return _controller.stream;
  }

  _startReceivingTypingEvents(User user, List<String> usersId) {
    _streamSubscriptionChangeFeed = rethinkdb
        .table('typing_events')
        .filter((event) => event('to')
            .eq(user.id)
            .and(rethinkdb.expr(usersId).contains(event('from'))))
        .changes({'include_initial': true})
        .run(connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final typing = _eventFromFeed(feedData);
                _controller.sink.add(typing);
                _removeEvent(typing);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  TypingEvent _eventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  _removeEvent(TypingEvent event) {
    rethinkdb
        .table('typing_events')
        .get(event.id)
        .delete({'return_changes': false}).run(connection);
  }

  @override
  dispose() {
    _streamSubscriptionChangeFeed?.cancel();
    _controller.close();
  }
}
