import 'package:chat/models/receipt.dart';
import 'package:chat/models/user.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> receipts(User user);
  dispose();
}
