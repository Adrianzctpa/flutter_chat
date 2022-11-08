import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/services/chat/chat_firebase_service.dart';
// import 'package:flutter_chat/core/services/chat/chat_mock_service.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messages();
  Future<ChatMessage?> sendMessage(ChatMessage msg);

  factory ChatService() {
    return ChatFirebaseService();
    // return ChatMockService();
  }
}