import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/CommentTile.dart';
import 'package:threads_clone/components/PostTile.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/navigation/navigation.dart';

import '../services/database/database_provider.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  @override
  Widget build(BuildContext context) {
    final allComments = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(foregroundColor: Theme.of(context).colorScheme.primary),
      body: ListView(
        children: [
          Posttile(
            post: widget.post,
            onUserTap: () => navigateToUserProfile(context, widget.post.uid),
            onPostTap: () {},
          ),

          allComments.isEmpty
              ? Center(child: Text("No comments yet!"))
              : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allComments.length,
                itemBuilder: (context, index) {
                  final comment = allComments[index];
                  return CommentTile(comment: comment, onUserTap: ()=> navigateToUserProfile(context, comment.uid));
                },
              ),
        ],
      ),
    );
  }
}
