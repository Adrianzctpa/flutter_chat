import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/core/services/auth/auth_firebase_service.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:flutter_chat/core/models/chat_message.dart';

class ChatFirebaseService implements ChatService {
  
  @override
  Stream<List<ChatMessage>> messages() {
    final store = FirebaseFirestore.instance;

    final snapshots = store.collection('chat')
    .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
    .orderBy('createdAt', descending: true)
    .snapshots();

    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshot) {
        final List<ChatMessage> messages = snapshot.docs.map((doc) => doc.data()).toList();
        controller.add(messages);
      });
    });
  }

  @override
  Future<ChatMessage?> sendMessage(ChatMessage msg) async {
    final store = FirebaseFirestore.instance;

    if (msg.username == '') {
      AuthFireBaseService().signOut();
      return null;
    }

    if (msg.messageType == 'image') {
      final img = File(msg.image!);
      final imgName = 'sentBy${msg.username}in${DateTime.now().toString()}.jpg';
      final imgUrl = await _uploadImage(img, imgName);
      msg.image = imgUrl;
    }

    final docRef = await store.collection('chat')
    .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
    .add(msg);
    final doc = await docRef.get();

    return doc.data()!;
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'messageContent': msg.messageContent,
      'messageType': msg.messageType,
      'createdAt': msg.createdAt,
      'image': msg.image,
      'uid': msg.uid,
      'username': msg.username,
      'userAvatar': msg.userAvatar,
    };
  }

  ChatMessage _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {  
    final data = {
      ...doc.data()!,
      'id': doc.id,
    };

    return ChatMessage.fromJson(data);
  }

  Future<String?> _uploadImage(File? img, String name) async {
    if (img == null) return null;
    
    final storage = FirebaseStorage.instance;
    final imgRef = storage.ref().child('user_images').child(name);
    await imgRef.putFile(img).whenComplete(() {});
    return await imgRef.getDownloadURL();
  }
}