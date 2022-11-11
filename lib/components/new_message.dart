import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_message.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/chat/chat_service.dart';
import 'package:image_picker/image_picker.dart';

enum Img {exists, doesNotExist}

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _msg = '';
  final _msgController = TextEditingController();
  File? _img;
  Img _image = Img.doesNotExist;

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser();

    if (user != null) {
      final json = {
        'id': '',
        'messageContent': _msg,
        'messageType': _image == Img.exists ? 'image' : 'text',
        'createdAt': DateTime.now(),
        'image': _image == Img.exists ? _img!.path : null, 
        'uid': user.id,
        'username': user.name,
        'userAvatar': user.imageUrl,
      };
      final msg = ChatMessage.fromJson(json);
      
      await ChatService().sendMessage(msg);
      _msgController.clear();

      _clearImageData();
    }
  }
  
  Future<void> _handleImagePick() async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImg == null) return;

    setState(() {
      _img = File(pickedImg.path);
      _image = Img.exists;
    });
  }

  void _clearImageData() {
    setState(() {
      _img = null;
      _image = Img.doesNotExist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image == Img.exists) 
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                _img!,
                fit: BoxFit.contain,
                width: double.infinity,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgController,
                onChanged: (value) {
                  setState(() => _msg = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Send a message...',
                ),
              ),
            ),
            if (_image == Img.exists) 
              IconButton(
                onPressed: _clearImageData,
                icon: const Icon(Icons.cancel),
              ),
            IconButton(
              onPressed: _handleImagePick,
              icon: const Icon(Icons.image),
            ),
            IconButton(
              onPressed: _msg.trim().isEmpty ? null : _sendMessage, 
              icon: const Icon(Icons.send)
            )
          ]
        ),
      ],
    );
  }
}