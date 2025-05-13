import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threads_clone/components/CustomLoader.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_service.dart';

import '../components/CustomTextField.dart';

class Register extends StatefulWidget {
  void Function()? togglePage;

  Register({super.key, required this.togglePage});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  final _db = DatabaseService();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void registerUser() async {
    if (password.text == confirmPassword.text) {
      try {
        showLoader(context);
        await _auth.registerEmailPassword(email.text, password.text);
        if (mounted) hideLoader(context);
        await _db.saveUserDetailsInFirebase(name: name.text, email: email.text);
      } catch (e) {
        if (mounted) hideLoader(context);
        if (mounted)
          Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        print(e);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Passwords don't match!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
                    "Let's create an account for you!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            
                CustomTextField(
                  controller: name,
                  obscureText: false,
                  hintText: "Enter Name",
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
            
                CustomTextField(
                  controller: confirmPassword,
                  obscureText: true,
                  hintText: "Confirm Password",
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
                        "Register",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: registerUser,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePage,
                  child: Text(
                    "Already a member? Login now.",
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
