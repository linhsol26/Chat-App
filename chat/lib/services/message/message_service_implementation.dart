import 'dart:async';

import 'package:chat/models/user.dart';
import 'package:chat/models/message.dart';
import 'package:chat/services/encryption/encryption_service_contract.dart';
import 'package:chat/services/message/message_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Connection connection;
  final Rethinkdb rethinkdb;
  final IEncryptionService encryption;

  MessageService(
      {required this.connection,
      required this.rethinkdb,
      required this.encryption});

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _streamSubscriptionChangeFeed;

  @override
  dispose() {
    _streamSubscriptionChangeFeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  _startReceivingMessages(User user) {
    _streamSubscriptionChangeFeed = rethinkdb
        .table('messages')
        .filter({'to': user.id})
        .changes({'include_initial': true})
        .run(connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final message = _messageFromFeed(feedData);

                _controller.sink.add(message);
                _removeDeliveredMessage(message);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  _removeDeliveredMessage(Message message) {
    rethinkdb
        .table('messages')
        .get(message.id)
        .delete({'return_changes': false}).run(connection);
  }

  Message _messageFromFeed(feedData) {
    var data = feedData['new_val'];
    data['contents'] = encryption.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  @override
  Future<bool> send(Message message) async {
    var data = message.toJson();
    data['contents'] = encryption.encrypt(message.contents);
    print(data['contents']);
    Map record = await rethinkdb.table('messages').insert(data).run(connection);
    return record['inserted'] == 1;
  }
}
