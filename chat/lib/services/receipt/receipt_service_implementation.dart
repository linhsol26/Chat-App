import 'dart:async';

import 'package:chat/models/user.dart';
import 'package:chat/models/receipt.dart';
import 'package:chat/services/receipt/receipt_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ReceiptService implements IReceiptService {
  final Connection connection;
  final Rethinkdb rethinkdb;

  ReceiptService({
    required this.connection,
    required this.rethinkdb,
  });

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription? _streamSubscriptionChangeFeed;

  @override
  dispose() {
    _streamSubscriptionChangeFeed?.cancel();
    _controller.close();
  }

  _startReceivingReceipts(User user) {
    _streamSubscriptionChangeFeed = rethinkdb
        .table('receipts')
        .filter({'recipient': user.id})
        .changes({'include_initial': true})
        .run(connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final receipt = _receiptFromFeed(feedData);

                _controller.sink.add(receipt);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  Receipt _receiptFromFeed(feedData) {
    var data = feedData['new_val'];
    return Receipt.fromJson(data);
  }

  @override
  Future<bool> send(Receipt receipt) async {
    var data = receipt.toJson();
    Map record = await rethinkdb.table('receipts').insert(data).run(connection);
    return record['inserted'] == 1;
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }
}
