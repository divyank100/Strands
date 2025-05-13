import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/InputAlertBox.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_provider.dart';
import '../helper/timestamp_formartter.dart';
import '../models/post.dart';

class Posttile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const Posttile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<Posttile> createState() => _PosttileState();
}

class _PosttileState extends State<Posttile> {
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  void reportPostConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Report Message"),
            content: Text("Are you sure you want to report this message?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await databaseProvider.reportUser(
                    widget.post.id,
                    widget.post.uid,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Message Reported!")));
                },
                child: Text("Report"),
              ),
            ],
          ),
    );
  }

  void blockUserConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Block User"),
            content: Text("Are you sure you want to block this user?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await databaseProvider.blockUser(widget.post.uid);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("User blocked!!")));
                },
                child: Text("Block"),
              ),
            ],
          ),
    );
  }

  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String currentUserId = AuthService().getCurrentUserId();
        bool isOwnPost = widget.post.uid == currentUserId;

        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnPost)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context);
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text("Report"),
                  onTap: () async {
                    Navigator.pop(context);
                    reportPostConfirmation();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block),
                  title: Text("Block User"),
                  onTap: () async {
                    Navigator.pop(context);
                    blockUserConfirmation();
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

  Future<void> loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) return;
    try {
      await databaseProvider.addComment(
        widget.post.id,
        commentController.text.trim(),
      );
      commentController.clear();
    } catch (e) {
      print(e);
    }
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => InputAlertBox(
            controller: commentController,
            hintText: "Type a comment...",
            onPress: () async {
              await addComment();
            },
            onPressText: "Add Comment",
          ),
    );
  }

  void toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    bool isPostLikedByCurrentUser = listeningProvider.isPostLikedByCurrentUser(
      widget.post.id,
    );
    int likeCount = listeningProvider.getLikeCount(widget.post.id);
    int commentCount = listeningProvider.getComments(widget.post.id).length;
    return GestureDetector(
      onTap: widget.onPostTap,
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
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "@${widget.post.userName}",
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
            Text(widget.post.message),
            SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child:
                            isPostLikedByCurrentUser
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(
                                  Icons.favorite_border,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: showCommentDialog,
                  child: Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 5),
                      Text(
                        commentCount != 0 ? commentCount.toString() : '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  formatTimestamp(widget.post.timestamp),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
