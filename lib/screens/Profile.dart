import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/BioBox.dart';
import 'package:threads_clone/components/InputAlertBox.dart';
import 'package:threads_clone/components/PostTile.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/screens/Settings.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_provider.dart';

import '../navigation/navigation.dart';

class Profile extends StatefulWidget {
  String uid;

  Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController bioController = TextEditingController();

  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUserId();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAllPosts = listeningProvider.filterPost(currentUserId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(isLoading ? "" : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed:
                () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  ),
                },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              isLoading ? "" : "@" + user!.userName,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),

          SizedBox(height: 25),

          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: 25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                if (user !=null && user!.uid == currentUserId)
                  GestureDetector(
                    onTap: showEditBio,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          Biobox(text: isLoading ? "..." : user!.bio),

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10),
            child: Text(
              "Posts",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),

          userAllPosts.isEmpty
              ? Center(child: Text("No posts yet"))
              : ListView.builder(
                itemCount: userAllPosts.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final post = listeningProvider.allPosts[index];
                  return Posttile(
                    post: post,
                    onUserTap: () {},
                    onPostTap: () => navigateToPost(context, post),
                  );
                },
              ),
        ],
      ),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      isLoading = true;
    });
    await databaseProvider.updateUserBioInFirebase(bioController.text);
    await loadUser();
    setState(() {
      isLoading = false;
    });
  }

  void showEditBio() {
    showDialog(
      context: context,
      builder:
          (context) => InputAlertBox(
            controller: bioController,
            hintText: "Enter your bio",
            onPress: saveBio,
            onPressText: "Save Bio",
          ),
    );
  }
}
