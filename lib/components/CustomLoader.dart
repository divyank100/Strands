import 'package:flutter/material.dart';

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(child: CircularProgressIndicator()),
        ),
  );
}

void hideLoader(BuildContext context) {
  Navigator.pop(context);
}
