class ChatUser {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name, email: $email, imageUrl: $imageUrl)';
  }
}