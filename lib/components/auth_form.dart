import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_chat/models/auth_form_data.dart';
import 'package:flutter_chat/components/user_image_form.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({required this.onSubmit, Key? key}) : super(key: key);

  final void Function(AuthFormData) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData(email: '', password: '', name: '');

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if(_formData.img == null && _formData.isSignUp) {
      return _showError('Please select an image');
    }

    widget.onSubmit(_formData);
  }

  void _handleImagePick(File image) {
    _formData.img = image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignUp)
                UserImageForm(onImagePick: _handleImagePick),
              TextFormField(
                key: const ValueKey('email'),
                onChanged: (email) => _formData.email = email,
                initialValue: _formData.email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (valEmail) {
                  final email = valEmail ?? '';

                  if (email.isEmpty || !email.contains('@')) {
                    return 'Please enter a valid email address';
                  }

                  return null;
                }
              ),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('name'),
                  onChanged: (name) => _formData.name = name,
                  initialValue: _formData.name,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (valName) {
                    final name = valName ?? '';

                    if (name.isEmpty) {
                      return 'Please enter a name';
                    }

                    if (name.trim().length < 4) {
                      return 'Name must be at least 4 characters long';
                    }

                    return null;
                  }
                ),
              TextFormField(
                key: const ValueKey('password'),
                onChanged: (password) => _formData.password = password,
                initialValue: _formData.password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (valPass) {
                  final pass = valPass ?? '';

                  if (pass.isEmpty) {
                    return 'Please enter a password';
                  }

                  if (pass.trim().length < 6) {
                    return 'Password must be at least 6 characters long';
                  }

                  return null;
                }
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_formData.isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formData.toggleAuth();
                  });
                },
                child: Text(_formData.isLogin ? 'Create new account' : 'I already have an account'),
              ),
            ],
          )
        ),
      )
    );
  }
}
