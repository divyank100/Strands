import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/services/database/database_provider.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );

  @override
  void initState() {
    super.initState();
    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  void showUnblockUserConfirmation(String blockedUserid) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Unlock User"),
            content: Text("Are you sure you want to unblock this user?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await databaseProvider.unblockUser(blockedUserid);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("User unblocked")));
                },
                child: Text("Unblock"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockedUsers = listeningProvider.blockedUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body:
          blockedUsers.isEmpty
              ? Center(child: Text("No blocked users!"))
              : ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text("@" + user.userName),
                    trailing: IconButton(
                      icon: Icon(Icons.block),
                      onPressed: ()=>showUnblockUserConfirmation(user.uid),
                    ),
                  );
                },
              ),
    );
  }
}
