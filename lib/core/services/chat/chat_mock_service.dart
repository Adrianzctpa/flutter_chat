import 'dart:async';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:flutter_chat/core/models/chat_message.dart';

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
  Future<ChatMessage> sendMessage(ChatMessage msg) async {
    _msgs.add(msg);
    _controller?.add(_msgs.reversed.toList());
    return msg;
  }
}