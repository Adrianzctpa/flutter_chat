import 'package:flutter/material.dart';
import 'package:flutter_chat/core/services/auth/auth_mock_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Chat Page'),
        TextButton(
          onPressed: () {
            AuthMockService().signOut();
          }, 
          child: const Text('Logout'))
      ],
    );
  }
}