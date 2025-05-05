import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  bool obscureText;
  String hintText;

  CustomTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: CupertinoTextField(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        placeholder: hintText,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        // suffix: GestureDetector(
        //   onTap: () {
        //     setState(() {
        //       obscurePassword = !obscurePassword;
        //     });
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //     child: Icon(
        //       obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
        //       color: Theme.of(context).colorScheme.primary,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
