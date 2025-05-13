import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/BottomNavBar.dart';
import 'package:threads_clone/components/InputAlertBox.dart';
import 'package:threads_clone/screens/AllPosts.dart';
import 'package:threads_clone/screens/Profile.dart';
import 'package:threads_clone/screens/Search.dart';
import 'package:threads_clone/screens/Settings.dart';
import 'package:threads_clone/services/auth/auth_service.dart';

import '../services/database/database_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController postMessageController = TextEditingController();
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  final auth = AuthService();
  late List<Widget> screens = [];
  int selectedScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      AllPosts(),
      Search(),
      AllPosts(),
      Profile(uid: auth.getCurrentUserId()),
      Settings()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        onTabClick: (index) => onTabClick(index),
      ),
      body: screens[selectedScreenIndex],
    );
  }

  void onTabClick(int index) {
    if (index == 2) {
      showPostMessageDialog();
    } else {
      setState(() {
        selectedScreenIndex = index;
      });
    }
  }

  void showPostMessageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => InputAlertBox(
            controller: postMessageController,
            hintText: "What's in your mind ?",
            onPress: () async {
              if (postMessageController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please write something to post");
                return;
              }
              await postMessage(postMessageController.text);
            },
            onPressText: "Post",
          ),
    );
  }

  Future<void> postMessage(String message) async {
    try {
      await databaseProvider.postMessage(message);
    } catch (e) {
      print(e);
    }
  }
}
