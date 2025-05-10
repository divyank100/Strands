import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:threads_clone/models/Comment.dart';
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

  // Delete user info
  Future<void> deleteUserInfoFromFirebase(String uid) async{
    WriteBatch batch=_db.batch();
    //Users
    DocumentReference userDoc= await _db.collection("Users").doc(uid);
    batch.delete(userDoc);

    //Posts
    QuerySnapshot userPosts=await _db.collection("Posts").where('uid',isEqualTo:uid).get();
    for(var post in userPosts.docs){
      batch.delete(post.reference);
    }

    //Comments
    QuerySnapshot userComments=await _db.collection("Comments").where('uid',isEqualTo:uid).get();
    for(var comment in userComments.docs){
      batch.delete(comment.reference);
    }

    //Likes
    QuerySnapshot allPosts= await _db.collection("Posts").get();
    for(QueryDocumentSnapshot post in allPosts.docs){
      Map<String,dynamic> postData= post.data() as Map<String,dynamic>;
      var likedBy=postData['likedBy'] as List<dynamic>? ?? [];
      if(likedBy.contains(uid)){
        batch.update(post.reference, {
          'likedBy':FieldValue.arrayRemove([uid]),
          'likeCount':FieldValue.increment(-1)
        });
      }
    }

    //Follow Unfollow(later)

    // commit the batch
    await batch.commit();
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
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  //   Likes
  Future<void> likeToggleInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection("Posts").doc(postId);
      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);
        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);
        int currentLikeCount = postSnapshot['likeCount'];

        if (!likedBy.contains(uid)) {
          likedBy.add(uid);
          currentLikeCount++;
        } else {
          likedBy.remove(uid);
          currentLikeCount--;
        }
        transaction.update(postDoc, {
          'likeCount': currentLikeCount,
          'likedBy': likedBy,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  // Comments
  //Add comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      UserProfile? user = await getUser(currentUserId);

      Comment comment = Comment(
        id: '',
        uid: currentUserId,
        postId: postId,
        message: message,
        name: user?.name ?? "",
        userName: user?.userName ?? "",
        timestamp: Timestamp.now(),
      );

      Map<String, dynamic> commentMap = comment.toMap();
      await _db.collection("Comments").add(commentMap);
    } catch (e) {
      print(e);
    }
  }

  //Delete comment to a post
  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  //Fetch comments to a post

  Future<List<Comment>> fetchCommentsOnPost(String postId) async {
    try {
      QuerySnapshot snapshot =
          await _db
              .collection("Comments")
              .where("postId", isEqualTo: postId)
              .get();
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Account stuff
  // Report post
  Future<void> reportPostInFirebase(String postId, userId) async {
    final currentUserId = _auth.currentUser!.uid;
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _db.collection("Reports").add(report);
  }

  // Block user
  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
  }

  // Unblock user
  Future<void> unblockUserInFirebase(String blockedUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();
  }

  // List of blocked user ids
  Future<List<String>> getBlockedUIdsFromFirebase() async {
    final currentUserId = _auth.currentUser!.uid;
    final snapshot =
        await _db
            .collection("Users")
            .doc(currentUserId)
            .collection("BlockedUsers")
            .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Follow/Unfollow

  // Search
}
