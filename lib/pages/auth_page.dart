import 'package:flutter/material.dart';
import 'package:flutter_chat/components/auth_form.dart';
import 'package:flutter_chat/models/auth_form_data.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  void _handleSubmit(AuthFormData formData) {
    setState(() {
      _isLoading = true;
    });
  
    debugPrint(formData.email);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          if (_isLoading) 
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5)
              ), 
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white
                ),
              ),
            ),
        ],
      ),
    );
  }
}