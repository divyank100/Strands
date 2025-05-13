import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threads_clone/components/CustomLoader.dart';
import 'package:threads_clone/components/CustomTextField.dart';
import 'package:threads_clone/services/auth/auth_service.dart';

class Login extends StatefulWidget {
  void Function()? togglePage;

  Login({super.key, required this.togglePage});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscurePassword = true;

  void login() async {
    try {
      showLoader(context);
      await _auth.loginEmailPassword(email.text, password.text);
      if(mounted) hideLoader(context);
    } catch (e) {
      if(mounted) hideLoader(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(
                    "Welcome back , you've been missed",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  controller: email,
                  obscureText: false,
                  hintText: "Enter Email",
                ),
            
                CustomTextField(
                  controller: password,
                  obscureText: true,
                  hintText: "Enter Password",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35.0,
                    horizontal: 15,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: CupertinoButton(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePage,
                  child: Text(
                    "Not a member? Register now.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
