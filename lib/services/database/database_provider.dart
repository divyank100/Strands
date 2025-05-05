import 'package:flutter/foundation.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();
  final _auth = AuthService();

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
    initLikeMap();
    notifyListeners();
  }

  // Get post for given uid
  List<Post> filterPost(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await getAllPosts();
  }

   //Local map to track like counts for each post
  Map<String,int> _likeCount={

  };

  // Local list to track posts liked by current user
  List<String> _likedPosts=[

  ];

  // Is post liked by curr user
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCount[postId] ?? 0;

  // initialize like map locally
  void initLikeMap(){
    final currentUserId=_auth.getCurrentUserId();
    _likedPosts.clear();
    for(var post in _allPosts){
      _likeCount[post.id]=post.likeCount;
      if(post.likedBy.contains(currentUserId)){
        _likedPosts.add(post.id);
      }
    }
  }

  // Toggle Like a post
  Future<void> toggleLike(String postId) async{
    final likedPostsOriginal=_likedPosts;
    final likeCountOriginal=_likeCount;

    if(_likedPosts.contains(postId)){
      _likedPosts.remove(postId);
      _likeCount[postId]= (_likeCount[postId] ?? 0)-1;
    }
    else{
      _likedPosts.add(postId);
      _likeCount[postId]= (_likeCount[postId] ?? 0)+1;
    }

    notifyListeners();

    try{
      await _db.likeToggleInFirebase(postId);
    }
    catch(e){
      _likedPosts = likedPostsOriginal;
      _likeCount = likeCountOriginal;
      notifyListeners();
    }

  }

}
