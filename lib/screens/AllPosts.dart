import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/PostTile.dart';
import 'package:threads_clone/navigation/navigation.dart';
import 'package:threads_clone/services/database/database_provider.dart';

import '../services/auth/auth_service.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  late final databaseListener = Provider.of<DatabaseProvider>(context);

  @override
  void initState() {
    super.initState();
    loadAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body:
          databaseListener.allPosts.isEmpty
              ? Center(child: Text("Nothing to show up here!"))
              : ListView.builder(
                itemCount: databaseListener.allPosts.length,
                itemBuilder: (context, index) {
                  final post = databaseListener.allPosts[index];
                  return Posttile(
                    post: post,
                    onUserTap: () => navigateToUserProfile(context, post.uid),
                    onPostTap: ()=>navigateToPost(context, post),
                  );
                },
              ),
    );
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.getAllPosts();
  }
}
