import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/UserListTile.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/services/database/database_provider.dart';

class FollowingList extends StatefulWidget {
  final String uid;

  const FollowingList({super.key, required this.uid});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );

  @override
  void initState() {
    super.initState();
    loadFollowers();
    loadFollowing();
  }

  Future<void> loadFollowers() async {
    await databaseProvider.loadFollowersProfile(widget.uid);
  }

  Future<void> loadFollowing() async {
    await databaseProvider.loadFollowingProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningProvider.getListOfFollowers(widget.uid);
    final following = listeningProvider.getListOfFollowing(widget.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            dividerColor: Colors.transparent,
            tabs: [Tab(text: "Followers"), Tab(text: "Following")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers.."),
            _buildUserList(following, "No following.."),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
  return userList.isEmpty
      ? Center(child: Text(emptyMessage))
      : ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return UserTile(user: user);
        },
      );
}
