import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final Widget action;
  void  Function()? onTap;

  SettingTile({super.key, required this.title, required this.action,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            action,
          ],
        ),
      ),
    );
  }
}
