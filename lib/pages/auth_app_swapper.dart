import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_user.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/pages/auth_page.dart';  
import 'package:flutter_chat/pages/chat_page.dart';  
import 'package:flutter_chat/pages/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthAppSwapper extends StatelessWidget {
  const AuthAppSwapper({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } 

        return StreamBuilder<ChatUser?>(
          stream: AuthService().userStateChanges(),
          builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else {
              return snapshot.hasData ? const ChatPage() : const AuthPage();
            }
          }
        );
      },
    );
  }
}