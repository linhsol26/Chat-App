import 'package:chat_app/models/local_message.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage> messages = [];
  late LocalMessage mostRecent;
  Chat(this.id);

  Chat.withMessage(this.id, {required messages, required mostRecent}) {
    this.id = id;
    this.messages = messages;
    this.mostRecent = mostRecent;
  }

  toMap() => {'id': id};

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);
}
