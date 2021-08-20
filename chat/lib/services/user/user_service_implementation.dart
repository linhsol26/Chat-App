import 'package:chat/models/user.dart';
import 'package:chat/services/user/user_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  final Rethinkdb rethinkdb;
  final Connection connection;

  UserService(this.rethinkdb, this.connection);

  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    data['id'] = rethinkdb.uuid();

    final result = await rethinkdb.table('users').insert(data, {
      'conflict': 'update',
      'return_changes': true,
    }).run(connection);
    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    await rethinkdb.table('users').update({
      'id': user.id,
      'active': false,
      'last_seen': DateTime.now()
    }).run(connection);

    connection.close();
  }

  @override
  Future<List<User>> online() async {
    Cursor users =
        await rethinkdb.table('users').filter({'active': true}).run(connection);
    final listUser = await users.toList();
    return listUser.map((user) => User.fromJson(user)).toList();
  }
}
