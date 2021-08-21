import 'package:chat/models/message.dart';
import 'package:chat/models/receipt.dart';
import 'package:chat/services/user/user_service_contract.dart';
import 'package:chat_app/data/datasources/datasource_contract.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view/models/base_view.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;
  ChatsViewModel(this._dataSource) : super(_dataSource);

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
        chatId: message.from,
        message: message,
        receipt: ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }

  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    return chats;
  }
}
