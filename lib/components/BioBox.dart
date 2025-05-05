import 'package:flutter/material.dart';

class Biobox extends StatelessWidget {
  final String text;
  Biobox({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary
      ),
      child: Text( text.isNotEmpty ? text : "Empty Bio"),
    );
  }
}
