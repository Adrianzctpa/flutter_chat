import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String messageContent;
  final String messageType;
  final DateTime createdAt;

  final String uid;
  final String username;
  final String userAvatar;

  ChatMessage({
    required this.id,
    required this.messageContent,
    required this.messageType,
    required this.createdAt,
    required this.uid,
    required this.username,
    required this.userAvatar,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      messageContent: json['messageContent'],
      messageType: json['messageType'],
      createdAt: parseTime(json['createdAt']),
      uid: json['uid'],
      username: json['username'],
      userAvatar: json['userAvatar'],
    );
  }

  static DateTime parseTime(dynamic date) {
    return date.runtimeType == Timestamp ? (date as Timestamp).toDate() : date as DateTime;
  }
}