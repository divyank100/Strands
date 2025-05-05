import 'package:flutter/foundation.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUser(uid);

  // update the user bio
  Future<void> updateUserBioInFirebase(String bio) =>
      _db.updateUserBioInFirebase(bio);

  // local list for all posts
  List<Post> _allPosts = [];

  List<Post> get allPosts => _allPosts;

  // Post a message
  Future<void> postMessage(String message) async {
      await _db.postMessageInFirebase(message);
      await getAllPosts();
  }

  // Get all posts
  Future<void> getAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();
    _allPosts = allPosts;
    notifyListeners();
  }

  // Get post for given uid
  List<Post> filterPost(String uid){
    return _allPosts.where((post)=> post.uid == uid).toList();
  }
}
