import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_provider.dart';
import '../models/post.dart';

class Posttile extends StatelessWidget {
  final Post post;
  void Function()? onUserTap;
  void Function()? onPostTap;

  Posttile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    late final databaseProvider = Provider.of<DatabaseProvider>(
      context,
      listen: false,
    );
    late final listeningProvider = Provider.of<DatabaseProvider>(context);

    void showOptions() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          String currentUserId = AuthService().getCurrentUserId();
          bool isOwnPost = post.uid == currentUserId;

          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnPost)
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                    onTap: () async {
                      Navigator.pop(context);
                      await databaseProvider.deletePost(post.id);
                    },
                  )
                else ...[
                  ListTile(
                    leading: Icon(Icons.flag),
                    title: Text("Report"),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.block),
                    title: Text("Block User"),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],

                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text("Cancel"),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    bool isPostLikeByCurrentUser = listeningProvider.isPostLikedByCurrentUser(
      post.id,
    );
    int likeCount = listeningProvider.getLikeCount(post.id);

    void toggleLikePost() async {
      try {
        await databaseProvider.toggleLike(post.id);
      } catch (e) {
        print(e);
      }
    }

    return GestureDetector(
      onTap: onPostTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
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
                    post.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "@" + post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            Text(post.message),

            SizedBox(height: 15),

            Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child:
                      isPostLikeByCurrentUser
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                ),
                SizedBox(width: 5),
                Text(
                  likeCount!=0 ? likeCount.toString() : '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
