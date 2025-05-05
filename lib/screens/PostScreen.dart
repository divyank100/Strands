import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/components/PostTile.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/navigation/navigation.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          Posttile(
            post: widget.post,
            onUserTap: () => navigateToUserProfile(context, widget.post.uid),
            onPostTap: () {},
          ),
        ],
      ),
    );
  }
}
