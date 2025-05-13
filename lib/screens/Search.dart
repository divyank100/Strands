import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/UserListTile.dart';
import 'package:threads_clone/services/database/database_provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(
      context,
      listen: false,
    );
    final listeningProvider = Provider.of<DatabaseProvider>(context);
    return Center(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                listeningProvider.searchUsers(value);
              } else {
                listeningProvider.searchUsers("");
              }
            },
          ),
        ),
        body:
            listeningProvider.searchResults.isEmpty
                ? Center(child: Text("No users found"))
                : ListView.builder(
                  itemCount: listeningProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = listeningProvider.searchResults[index];
                    return UserTile(user: user);
                  },
                ),
      ),
    );
  }
}
