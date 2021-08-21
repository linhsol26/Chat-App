// @dart = 2.9
import 'dart:math';

import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/encryption/encryption_service_implement.dart';
import 'package:chat/services/message/message_service_implementation.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  MessageService messageService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    final encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(rethinkdb, connection);
    messageService = MessageService(
        connection: connection, rethinkdb: rethinkdb, encryption: encryption);
  });

  tearDown(() async {
    messageService.dispose();
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

  test('sent message successfully', () async {
    Message message = Message(
        from: user.id,
        to: '3456',
        timeStamp: DateTime.now(),
        contents: 'This is a message.');
    final res = await messageService.send(message);
    expect(res, true);
  });

  test('successfully subcribe and receive messages', () async {
    messageService.messages(activeUser: user1).listen(expectAsync1((message) {
          expect(message.to, user1.id);
          expect(message.id, isNotEmpty);
        }, count: 2));

    Message message = Message(
        from: user.id,
        to: user1.id,
        timeStamp: DateTime.now(),
        contents: 'This is first message from 1 to 2.');

    Message secondMessage = Message(
        from: user.id,
        to: user1.id,
        timeStamp: DateTime.now(),
        contents: 'This is second message from 1 to 2.');

    await messageService.send(message);
    await messageService.send(secondMessage);
  });

  test('successfully subcribe and receive new messages', () async {
    Message message = Message(
        from: user.id,
        to: user1.id,
        timeStamp: DateTime.now(),
        contents: 'This is first message from 1 to 2.');

    Message secondMessage = Message(
        from: user.id,
        to: user1.id,
        timeStamp: DateTime.now(),
        contents: 'This is second message from 1 to 2.');

    await messageService.send(message);
    await messageService.send(secondMessage).whenComplete(() => messageService
        .messages(activeUser: user1)
        .listen(expectAsync1((message) {
          expect(message.to, user1.id);
        }, count: 2)));
  });
}
