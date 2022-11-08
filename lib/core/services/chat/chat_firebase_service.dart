import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:flutter_chat/core/models/chat_message.dart';

class ChatFirebaseService implements ChatService {
  
  @override
  Stream<List<ChatMessage>> messages() {
    return const Stream<List<ChatMessage>>.empty();
  }

  @override
  Future<ChatMessage?> sendMessage(ChatMessage msg) async {
    final store = FirebaseFirestore.instance;

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
}