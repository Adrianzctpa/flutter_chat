import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImageForm extends StatefulWidget {
  const UserImageForm({required this.onImagePick, Key? key}) : super(key: key);

  final void Function(File) onImagePick;

  @override
  State<UserImageForm> createState() => _UserImageFormState();
}

class _UserImageFormState extends State<UserImageForm> {
  File? _img;

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
    });

    widget.onImagePick(_img!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _img != null ? FileImage(_img!) : null,
        ),
        TextButton(
          onPressed: _handleImagePick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(width: 5),
              Text(
                'Add Image',
                style: TextStyle(color: Theme.of(context).primaryColor)
              ),
            ],
          ),
        )
      ]
    );
  }
}