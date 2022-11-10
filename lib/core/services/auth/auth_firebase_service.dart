import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

    final imgName = '${creds.user!.uid}.jpg';
    final imgUrl = await _uploadImage(img, imgName);

    await creds.user?.updateDisplayName(name);
    await creds.user?.updatePhotoURL(imgUrl ?? avatarPath);
  
    _currentUser = _toChatUser(creds.user!, imgUrl, name);
    await _saveUser(_currentUser!);
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

  Future<String?> _uploadImage(File? img, String name) async {
    if (img == null) return null;

    final storage = FirebaseStorage.instance;
    final imgRef = storage.ref().child('user_images').child(name);
    await imgRef.putFile(img).whenComplete(() {});
    return await imgRef.getDownloadURL();
  }

  Future<void> _saveUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    store.collection('users').doc(user.id).set(user.toJson());
  }

  static ChatUser _toChatUser(User user, [String? imageUrl, String? name]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email ?? '',
      imageUrl: imageUrl ??  user.photoURL ?? avatarPath,
    ); 
  }
}