import '../datasources/gemini_service.dart';

class ChatRepository {
  final GeminiService service;

  ChatRepository(this.service);

  Future<String> sendMessage(String message) {
    return service.sendMessage(message);
  }
}