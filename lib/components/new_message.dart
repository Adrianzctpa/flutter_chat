import 'package:flutter/material.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _msg = '';
  final _msgController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser();

    if (user != null) {
      await ChatService().sendMessage(_msg, user);
      _msgController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _msgController,
            onChanged: (value) {
              setState(() => _msg = value);
            },
            decoration: const InputDecoration(
              labelText: 'Send a message...',
            ),
          ),
        ),
        IconButton(
          onPressed: _msg.trim().isEmpty ? null : _sendMessage, 
          icon: const Icon(Icons.send)
        )
      ]
    );
  }
}