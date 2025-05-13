import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/screens/Home.dart';
import 'package:threads_clone/screens/PostScreen.dart';
import 'package:threads_clone/screens/Profile.dart';

import '../models/post.dart';
import '../screens/AccountSettings.dart';
import '../screens/BlockedUsersScreen.dart';

void navigateToUserProfile(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Profile(uid: uid)),
  );
}

void navigateToPost(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PostScreen(post: post)),
  );
}

void navigateToBlockedUsers(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BlockedUsersScreen()),
  );
}

void navigateToAccountSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AccountSettings()),
  );
}

void navigateToAllPosts(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Home()),
    (route) => route.isFirst,
  );
}
