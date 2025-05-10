import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/models/Comment.dart';
import 'package:threads_clone/services/database/database_provider.dart';

import '../models/post.dart';
import '../services/auth/auth_service.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });



  void showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String currentUserId = AuthService().getCurrentUserId();
        bool isOwnComment = comment.uid == currentUserId;

        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnComment)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context);
                    await Provider.of<DatabaseProvider>(context,listen: false).deleteComment(comment.id, comment.postId);
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text("Report"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block),
                  title: Text("Block User"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onUserTap,
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 5),
                Text(
                  comment.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "@${comment.userName}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showOptions(context);
                  },
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(comment.message),
        ],
      ),
    );
  }
}
