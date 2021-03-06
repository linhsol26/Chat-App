import 'package:chat/models/message.dart';
import 'package:chat/models/receipt.dart';

class LocalMessage {
  String chatId;
  late String _id;
  Message message;
  ReceiptStatus receipt;

  LocalMessage({
    required this.chatId,
    required this.message,
    required this.receipt,
  });

  String get id => _id;

  Map<String, dynamic> toMap() => {
        'chat_id': this.chatId,
        'id': this.message.id,
        'sender': message.from,
        'receiver': message.to,
        'contents': message.contents,
        'receipt': this.receipt.value(),
        'received_at': message.timestamp,
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
      contents: json['contents'],
      from: json['sender'],
      timestamp: json['received_at'],
      to: json['receiver'],
    );

    final localMessage = LocalMessage(
        chatId: json['chat_id'],
        message: message,
        receipt: EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }
}
