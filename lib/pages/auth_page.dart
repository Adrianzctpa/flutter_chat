import 'package:flutter/material.dart';
import 'package:flutter_chat/components/auth_form.dart';
import 'package:flutter_chat/core/models/auth_form_data.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      if (!mounted) return; 
      setState(() {
        _isLoading = true;
      });

      if (formData.isLogin) {
        await AuthService().logIn(formData.email, formData.password);
      } else {
        await AuthService().signUp(
          formData.email,
          formData.password,
          formData.name,
          formData.img!,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } 

    if (!mounted) return;
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