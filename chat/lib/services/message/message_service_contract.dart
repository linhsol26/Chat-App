import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';

abstract class IMessageService {
  Future<bool> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}
