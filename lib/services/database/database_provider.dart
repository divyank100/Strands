import 'package:flutter/foundation.dart';
import 'package:threads_clone/models/Comment.dart';
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
    // get blocked userIds
    final blockedUerIds = await _db.getBlockedUIdsFromFirebase();
    _allPosts =
        allPosts.where((post) => !blockedUerIds.contains(post.uid)).toList();

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
  Map<String, int> _likeCount = {};

  // Local list to track posts liked by current user
  List<String> _likedPosts = [];

  // Is post liked by curr user
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCount[postId] ?? 0;

  // initialize like map locally
  void initLikeMap() {
    final currentUserId = _auth.getCurrentUserId();
    _likedPosts.clear();
    for (var post in _allPosts) {
      _likeCount[post.id] = post.likeCount;
      if (post.likedBy.contains(currentUserId)) {
        _likedPosts.add(post.id);
      }
    }
  }

  // Toggle Like a post
  Future<void> toggleLike(String postId) async {
    final likedPostsOriginal = _likedPosts;
    final likeCountOriginal = _likeCount;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) + 1;
    }

    notifyListeners();

    try {
      await _db.likeToggleInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCount = likeCountOriginal;
      notifyListeners();
    }
  }

  /*

    Comments(MAP of posts-comments)
    {
      postId : [comment1,comment2]
      postId : [comment1,comment2]
      postId : [comment1,comment2]
    }

   */

  // local list of comments for each post
  Map<String, List<Comment>> _comments = {};

  // fetch comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // fetch comments from db for a post
  Future<void> loadComments(String postId) async {
    final allComments = await _db.fetchCommentsOnPost(postId);
    _comments[postId] = allComments;
    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    await _db.deleteCommentInFirebase(commentId);
    await loadComments(postId);
  }

  /*
  ACCOUNT STUFF
   */

  // local list of blocked users
  List<UserProfile> _blockedUsers = [];

  List<UserProfile> get blockedUser => _blockedUsers;

  // fetch blocked users
  Future<void> loadBlockedUsers() async {
    final blockedUids = await _db.getBlockedUIdsFromFirebase();

    final blockedUserData = await Future.wait(
      blockedUids.map((id) => _db.getUser(id)),
    );

    _blockedUsers = blockedUserData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  //block user
  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);

    await loadBlockedUsers();

    await getAllPosts();
  }

  // unblock user
  Future<void> unblockUser(String userId) async {
    await _db.unblockUserInFirebase(userId);

    await loadBlockedUsers();

    await getAllPosts();
  }

  // report user & post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportPostInFirebase(postId, userId);
  }
}
