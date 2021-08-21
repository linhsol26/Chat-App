import 'package:chat_app/data/datasources/datasource_contract.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/local_message.dart';

abstract class BaseViewModel {
  IDataSource _dataSource;

  BaseViewModel(this._dataSource);

  Future<void> addMessage(LocalMessage localMessage) async {
    if (!(await _isExistingChat(localMessage.chatId)))
      await _createNewChat(localMessage.chatId);
    await _dataSource.addMessage(localMessage);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != Chat('');
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _dataSource.addChat(chat);
  }
}
