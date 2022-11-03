import 'package:flutter/material.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/components/messages.dart';
import 'package:flutter_chat/components/new_message.dart';
import 'package:flutter_chat/core/services/notification/chat_notification_service.dart';
import 'package:flutter_chat/pages/notification_page.dart';
import 'package:provider/provider.dart';

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
        centerTitle: true,
        title: const Text('Chat'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
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
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed:() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.red,
                  child: Text(
                    Provider.of<ChatNotificationService>(context).itemsCount > 99
                    ? '99+'
                    : Provider.of<ChatNotificationService>(context).itemsCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
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