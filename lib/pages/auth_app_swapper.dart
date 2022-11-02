import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/pages/auth_page.dart';  
import 'package:flutter_chat/pages/chat_page.dart';  

class AuthAppSwapper extends StatelessWidget {
  const AuthAppSwapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<ChatUser?>(
         stream: AuthService().userStateChanges(),
         builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return snapshot.hasData ? const ChatPage() : const AuthPage();
            }
          }),
        ),
      ),
    );
  }
}