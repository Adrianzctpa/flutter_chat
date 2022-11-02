import 'package:flutter/material.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/components/messages.dart';
import 'package:flutter_chat/components/new_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Chat')),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            items: [
              DropdownMenuItem(
                value: 'signOut',
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
            onChanged: (val) {
              if (val == 'signOut') {
                AuthService().signOut();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Flexible(child: Messages()),
            NewMessage()
          ],
        ),
      ),
    );
  }
}