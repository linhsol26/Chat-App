// @dart = 2.9
import 'package:chat/models/user.dart';
import 'package:chat/services/user/user_service_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  UserService userService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    userService = UserService(rethinkdb, connection);
  });

  tearDown(() async {
    await cleanDb(rethinkdb, connection);
  });

  test('create new user in database', () async {
    final user = User(
        userName: 'test',
        photoUrl: 'url',
        active: true,
        lastSeen: DateTime.now());
    final userId = await userService.connect(user);
    print(userId.id);
    expect(userId.id, isNotEmpty);
  });

  test('get online users', () async {
    final user = User(
        userName: 'test',
        photoUrl: 'url',
        active: true,
        lastSeen: DateTime.now());
    await userService.connect(user);
    final users = await userService.online();
    expect(users.length, 1);
  });
}
