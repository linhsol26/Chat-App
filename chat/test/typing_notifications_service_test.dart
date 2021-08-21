// @dart = 2.9

import 'package:chat/models/typing_event.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/typing/typing_notifications_service_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  TypingNotificationsService typingService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    typingService = TypingNotificationsService(
        connection: connection, rethinkdb: rethinkdb);
  });

  tearDown(() async {
    typingService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final user = User.fromJson({
    'id': '1111',
    'active': true,
    'last_seen': DateTime.now(),
  });

  final user1 = User.fromJson({
    'id': '1111',
    'active': true,
    'last_seen': DateTime.now(),
  });

  test('send typing notifications successfully', () async {
    TypingEvent typingEvent = TypingEvent(
      event: Typing.start,
      to: user.id,
      from: user1.id,
    );
    final res = await typingService.send(event: typingEvent, to: user);
    expect(res, true);
  });

  test('successfully subcribe and receive messages', () async {
    typingService.subcribe(user1, [user.id]).listen(expectAsync1((event) {
      expect(event.from, user.id);
    }, count: 2));

    TypingEvent typing = TypingEvent(
      event: Typing.start,
      to: user.id,
      from: user1.id,
    );

    TypingEvent stop = TypingEvent(
      event: Typing.stop,
      to: user.id,
      from: user1.id,
    );

    await typingService.send(event: typing, to: user1);
    await typingService.send(event: stop, to: user1);
  });
}
