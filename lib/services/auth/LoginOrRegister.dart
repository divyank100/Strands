import 'package:flutter/material.dart';
import 'package:threads_clone/screens/Login.dart';
import 'package:threads_clone/screens/Register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Login(togglePage: togglePages);
    } else {
      return Register(togglePage: togglePages);
    }
  }
}
