class ChatMessage {
  final String id;
  final String messageContent;
  final String messageType;
  final DateTime createdAt = DateTime.now();

  final String uid;
  final String username;
  final String userAvatar;

  ChatMessage({
    required this.id,
    required this.messageContent,
    required this.messageType,    
    required this.uid,
    required this.username,
    required this.userAvatar,
  });
}