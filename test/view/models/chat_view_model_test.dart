// @dart = 2.9
import 'package:chat/models/message.dart';
import 'package:chat/models/receipt.dart';
import 'package:chat_app/data/datasources/datasource_contract.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view/models/chat_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDataSource {}

void main() {
  ChatViewModel sut;
  MockDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = ChatViewModel(mockDatasource);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial message return empty list', () async {
    when(mockDatasource.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });

  test('returns list of messages from local storage', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(
        chatId: chat.id, message: message, receipt: ReceiptStatus.deliverred);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await sut.getMessages('123');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });

  test('create new chat when send first message', () async {
    when(mockDatasource.findChat(any)).thenAnswer((_) async => Chat(''));
    await sut.sendMessage(message);
    verifyNever(mockDatasource.addChat(any));
  });

  test('add new sent message to the chat', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(
        chatId: chat.id, message: message, receipt: ReceiptStatus.deliverred);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    await sut.getMessages(chat.id);
    await sut.sendMessage(message);

    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = Chat('111');
    final localMessage = LocalMessage(
        chatId: chat.id, message: message, receipt: ReceiptStatus.deliverred);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => Chat(''));

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });

  test('create new chat when message received is not apart of current chat',
      () async {
    final chat = Chat('111');
    final localMessage = LocalMessage(
        chatId: chat.id, message: message, receipt: ReceiptStatus.deliverred);
    when(mockDatasource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDatasource.findChat(chat.id)).thenAnswer((_) async => Chat(''));

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
    expect(sut.otherMessage, 1);
  });
}
