import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/screens/PostScreen.dart';
import 'package:threads_clone/screens/Profile.dart';

import '../models/post.dart';

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
