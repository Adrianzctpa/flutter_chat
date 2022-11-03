import 'dart:async';
import 'dart:math';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/models/chat_user.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [];
  static MultiStreamController<List<ChatMessage>>? _controller;

  static final _msgStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });
  
  @override
  Stream<List<ChatMessage>> messages() {
    return _msgStream;
  }

  @override
  Future<ChatMessage> sendMessage(String message, ChatUser user) async {
    final msg = ChatMessage(
      id: Random().nextDouble().toString(),
      messageContent: message,
      messageType: 'text',
      uid: user.id,
      username: user.name,
      userAvatar: user.imageUrl,
    );

    _msgs.add(msg);
    _controller?.add(_msgs.reversed.toList());
    return msg;
  }
}