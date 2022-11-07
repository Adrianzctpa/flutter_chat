import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/models/chat_user.dart';

class AuthMockService implements AuthService {
  static const avatarPath = 'assets/images/avatar.png';
  static ChatUser? _currentUser;
  static final _defaultUser = ChatUser(
    id: '1',
    name: 'Default User',
    email: 'default@user.com',
    imageUrl: avatarPath,
  );
  static final Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser
  };

  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) { 
    _controller = controller;
    _updateUser(_defaultUser);
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
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageUrl: img?.path ?? avatarPath,
    );
    
    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  @override
  Future<void> logIn(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> signOut() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(user);
  }
}