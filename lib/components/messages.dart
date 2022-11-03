import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:flutter_chat/components/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser();
    return StreamBuilder(
      stream: ChatService().messages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("Let's chat!"));
        } else {
          final messages = snapshot.data as List<ChatMessage>;
          return ListView.builder(
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              return MessageBubble(
                key: ValueKey(messages[index].id),
                message: messages[index], 
                isMe: currentUser?.id == messages[index].uid
              );
            },
          );
        }
      },
    );
  }
}