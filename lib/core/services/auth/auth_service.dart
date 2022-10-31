import 'dart:io';
import 'package:flutter_chat/core/models/chat_user.dart';

abstract class AuthService {
  ChatUser? currentUser();

  Stream<ChatUser?> userStateChanges();

  Future<void> signUp(
    String email, 
    String password, 
    String name, 
    File? img
  );

  Future<void> logIn(
    String email, 
    String password
  );

  Future<void> signOut();
}