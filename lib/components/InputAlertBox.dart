import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputAlertBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  void Function()? onPress;
  final String onPressText;

  InputAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPress,
    required this.onPressText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          maxLength: 140,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Theme.of(context).colorScheme.secondary,
            counterStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          controller: controller,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clear();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPress!();
            controller.clear();
          },
          child: Text(onPressText),
        )
      ],
    );
  }
}
