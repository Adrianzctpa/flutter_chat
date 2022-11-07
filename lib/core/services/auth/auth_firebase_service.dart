import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/models/chat_user.dart';

class AuthFireBaseService implements AuthService {
  static const avatarPath = 'assets/images/avatar.png';
  static ChatUser? _currentUser;
  
  static final _userStream = Stream<ChatUser?>.multi((controller) async { 
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? currentUser() {
    return _currentUser;
  }  

  @override
  Stream<ChatUser?> userStateChanges() {
    return _userStream;
  }

  @override
  Future<void> signUp(String email, String password, String name, File? img) async {
    final auth = FirebaseAuth.instance;
    UserCredential creds =  await auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    if (creds.user == null) return;

    creds.user?.updateDisplayName(name);
    creds.user?.updatePhotoURL(img?.path ?? avatarPath);
  }

  @override
  Future<void> logIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  @override
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email ?? '',
      imageUrl: user.photoURL ?? avatarPath,
    ); 
  }
}