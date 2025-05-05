import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/services/auth/auth_service.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // User Profile

  Future<void> saveUserDetailsInFirebase({
    required String name,
    required String email,
  }) async {
    String uid = _auth.currentUser!.uid;
    String userName = email.split('@')[0];
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      userName: userName,
      bio: '',
      email: email,
    );

    final userMap = user.toMap();
    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<UserProfile?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection("Users").doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromDocument(doc);
      } else {
        print('User document not found for uid: $uid');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update UserBio
  Future<void> updateUserBioInFirebase(String bio) async {
    try {
      String uid = AuthService().getCurrentUserId();
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // Post message
  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUser(uid);

      Post post = Post(
        id: '',
        uid: uid,
        name: user!.name,
        userName: user.userName,
        message: message,
        likeCount: 0,
        likedBy: [],
        timestamp: Timestamp.now(),
      );

      final postMap = post.toMap();
      await _db.collection("Posts").add(postMap);
    } catch (e) {
      print(e);
    }
  }

  // Get all posts
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await _db
              .collection("Posts")
              .orderBy('timestamp', descending: true)
              .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Like post

  // Delete a post

  // Get individual post

  //   Likes

  // Comments

  // Account stuff

  // Follow/Unfollow

  // Search
}
