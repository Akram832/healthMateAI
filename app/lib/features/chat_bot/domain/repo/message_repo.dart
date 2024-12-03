import '../models/message.dart';

abstract class ChatRepository {
  Future<String> getBotResponse(String userMessage);
}
