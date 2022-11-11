import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, required this.isMe, Key? key}) : super(key: key);

  final ChatMessage message;
  final bool isMe;
  static const _defaultImg = 'assets/images/avatar.png';

  Widget _showUserAvatar(String imageUrl) {
    ImageProvider? prov;
    final uri = Uri.parse(imageUrl);

    if (uri.path.contains(_defaultImg)) {
      prov = const AssetImage(_defaultImg);
    } else if (uri.scheme.contains('http') || uri.scheme.contains('https')) {
      prov = NetworkImage(imageUrl);
    } else {
      prov = FileImage(File(imageUrl));
    }

    return CircleAvatar(
      backgroundImage: prov,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                )
              ),
              width: 180,
              margin: const EdgeInsets.symmetric(
                vertical: 15, 
                horizontal: 8
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.username, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.white
                    )
                  ),
                  Text(
                    message.messageContent,
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white
                    )
                  ),
                  if (message.messageType == 'image')
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(message.image!),
                          fit: BoxFit.cover
                        )
                      ),
                    )
                ],
              )
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 165,
          right: isMe ? 165 : null,
          child: _showUserAvatar(message.userAvatar),
        ),
      ],
    );
  }
}