import 'package:chat/models/typing_event.dart';
import 'package:chat/models/user.dart';

abstract class ITypingNofiticationsService {
  Future<bool> send({required TypingEvent event, required User to});
  Stream<TypingEvent> subcribe(User user, List<String> usersId);
  dispose();
}
