import 'dart:io';
enum Auth {signUp, logIn}

class AuthFormData {
  String email;
  String password;
  String name;
  File? img;
  Auth _auth = Auth.logIn;

  AuthFormData({required this.email, required this.password, required this.name, this.img});

  bool get isLogin {
    return _auth == Auth.logIn;
  }

  bool get isSignUp {
    return _auth == Auth.signUp;
  }

  void toggleAuth() {
    _auth = _auth == Auth.logIn ? Auth.signUp : Auth.logIn;
  }
}