import 'package:flutter/material.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/screens/Profile.dart';

class UserTile extends StatelessWidget {
  final UserProfile user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(uid: user.uid)),
            ),
        title: Text(user.name),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        subtitle: Text("@ ${user.userName}"),
        subtitleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),

        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
