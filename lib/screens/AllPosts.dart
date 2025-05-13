import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/PostTile.dart';
import 'package:threads_clone/models/post.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("H O M E"),
          leading: null,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            dividerColor: Colors.transparent,
            tabs: [Tab(text: "For you"), Tab(text: "Following")],
          ),
        ),
        body: TabBarView(children: [
          _buildPostList(databaseListener.allPosts),
          _buildPostList(databaseListener.followingPosts)
        ])
      ),
    );
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.getAllPosts();
  }

  Widget _buildPostList(List<Post> posts){
    return posts.isEmpty
        ? Center(child: Text("Nothing to show up here!"))
        : ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Posttile(
          post: post,
          onUserTap: () => navigateToUserProfile(context, post.uid),
          onPostTap: ()=>navigateToPost(context, post),
        );
      },
    );
  }
}


