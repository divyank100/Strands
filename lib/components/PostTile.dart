import 'package:flutter/material.dart';
import '../models/post.dart';

class Posttile extends StatelessWidget {
  final Post post;

  const Posttile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 5),
              Text(
                post.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "@" + post.userName,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),

          SizedBox(height: 15),

          Text(post.message),
        ],
      ),
    );
  }
}
