import 'package:chat/models/message.dart';
import 'package:chat/models/receipt.dart';
import 'package:chat_app/data/datasources/datasource_contract.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view/models/base_view.dart';

class ChatViewModel extends BaseViewModel {
  IDataSource _dataSource;
  String _chatId = '';
  int otherMessage = 0;
  ChatViewModel(this._dataSource) : super(_dataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sendMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        chatId: message.to, message: message, receipt: ReceiptStatus.sent);
    if (_chatId.isNotEmpty) return await _dataSource.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        chatId: message.from,
        message: message,
        receipt: ReceiptStatus.deliverred);
    if (localMessage.chatId != _chatId) otherMessage++;
    await addMessage(localMessage);
  }
}
