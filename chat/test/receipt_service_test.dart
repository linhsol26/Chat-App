// @dart = 2.9

import 'package:chat/models/receipt.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/receipt/receipt_service_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  ReceiptService receiptService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    receiptService =
        ReceiptService(connection: connection, rethinkdb: rethinkdb);
  });

  tearDown(() async {
    receiptService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final user = User.fromJson({
    'id': '1111',
    'active': true,
    'last_seen': DateTime.now(),
  });

  test('send receipt successfully', () async {
    Receipt receipt = Receipt(
        recipient: '111',
        messageId: '1234',
        status: ReceiptStatus.deliverred,
        timeStamp: DateTime.now());
    final res = await receiptService.send(receipt);
    expect(res, true);
  });

  test('successfully subcribe and receive messages', () async {
    receiptService.receipts(user).listen(expectAsync1((receipt) {
          expect(receipt.recipient, user.id);
        }, count: 2));

    Receipt receipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.deliverred,
        timeStamp: DateTime.now());

    Receipt anotherReceipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.read,
        timeStamp: DateTime.now());

    await receiptService.send(receipt);
    await receiptService.send(anotherReceipt);
  });
}
